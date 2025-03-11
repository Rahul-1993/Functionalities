//
//  BasicMarketStackView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/5/25.
//

import SwiftUI

struct TickersList: Codable {
    let pagination: Pagination
    let data: [Datum]
}

struct Datum: Codable, Identifiable {
    var id: String {ticker}
    let ticker: String
}

struct Pagination: Codable {
    let limit, offset, count, total: Int
}



class BasicMarketStackDataService {
    
    let ticketUrlString = "\(marketBaseUrl)\(marketTickerEndPoint)?access_key=\(marketApiKey)"
    
    func fetchTickerList() async -> TickersList? {
        do {
            if let ticketUrl = URL(string: ticketUrlString) {
                let (data, response) = try await URLSession.shared.data(from: ticketUrl)
                return handleResponse(data: data, response: response)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil

        
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> TickersList? {
        guard let data = data,
            let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        
        // Print JSON data in readable format
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response: \(jsonString)")
        } else {
            print("Unable to convert data to string")
        }
        
        do {
            return try JSONDecoder().decode(TickersList.self, from: data)
        } catch {
            print("decoding error")
            return nil
        }
        
    }
    
}

class BasicMarketStackViewModel: ObservableObject {
    @Published var tickersListArray: TickersList? = nil
    
    let dataService = BasicMarketStackDataService()
    
    init() {
        Task {
            await fetchTickerData()
        }
        
    }
    
    func fetchTickerData() async {
        let returnedData = await dataService.fetchTickerList()
        if let data = returnedData {
            print("ReturnedData ---", data)
            await MainActor.run {
                self.tickersListArray = data
            }
        }

        
    }
    
    
    
    
}

struct BasicMarketStackView: View {
    
    @StateObject var viewModel = BasicMarketStackViewModel()
    
    var body: some View {
        NavigationStack {
            List{
                if let tickerData = viewModel.tickersListArray?.data {
                    ForEach(tickerData) { ticker in
                        NavigationLink(value: ticker.ticker) {
                            Label(ticker.ticker, systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { tickerString in
                BasicMarketStackDetailsView(tickerString: tickerString)
            }
        }

    }
}

#Preview {
    BasicMarketStackView()
}
