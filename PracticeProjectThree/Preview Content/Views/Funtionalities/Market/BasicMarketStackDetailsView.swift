//
//  BasicMarketStackDetailsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/5/25.
//

import SwiftUI

struct BasicMarketStackDetails: Codable {
    let pagination: PaginationDetails
    let data: [DatumDetails]
}

// MARK: - Datum
struct DatumDetails: Codable, Identifiable {
    var id = UUID()
    let datumOpen, high, low, close: Double?
    let volume: Int?
    let adjHigh, adjLow, adjClose, adjOpen: Double?
    let adjVolume, splitFactor: Int?
    let dividend: Double?
    let name: String?
    let exchangeCode: String?
    let assetType: String?
    let priceCurrency: String?
    let symbol: String?
    let exchange: String?
    let date: Date?

    enum CodingKeys: String, CodingKey {
        case datumOpen = "open"
        case high, low, close, volume
        case adjHigh = "adj_high"
        case adjLow = "adj_low"
        case adjClose = "adj_close"
        case adjOpen = "adj_open"
        case adjVolume = "adj_volume"
        case splitFactor = "split_factor"
        case dividend, name
        case exchangeCode = "exchange_code"
        case assetType = "asset_type"
        case priceCurrency = "price_currency"
        case symbol, exchange, date
    }

    // Custom initializer to handle date decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        datumOpen = try container.decodeIfPresent(Double.self, forKey: .datumOpen)
        high = try container.decodeIfPresent(Double.self, forKey: .high)
        low = try container.decodeIfPresent(Double.self, forKey: .low)
        close = try container.decodeIfPresent(Double.self, forKey: .close)
        volume = try container.decodeIfPresent(Int.self, forKey: .volume)
        adjHigh = try container.decodeIfPresent(Double.self, forKey: .adjHigh)
        adjLow = try container.decodeIfPresent(Double.self, forKey: .adjLow)
        adjClose = try container.decodeIfPresent(Double.self, forKey: .adjClose)
        adjOpen = try container.decodeIfPresent(Double.self, forKey: .adjOpen)
        adjVolume = try container.decodeIfPresent(Int.self, forKey: .adjVolume)
        splitFactor = try container.decodeIfPresent(Int.self, forKey: .splitFactor)
        dividend = try container.decodeIfPresent(Double.self, forKey: .dividend)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        exchangeCode = try container.decodeIfPresent(String.self, forKey: .exchangeCode)
        assetType = try container.decodeIfPresent(String.self, forKey: .assetType)
        priceCurrency = try container.decodeIfPresent(String.self, forKey: .priceCurrency)
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        exchange = try container.decodeIfPresent(String.self, forKey: .exchange)

        // Handling the date conversion from String to Date
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // Format with timezone

            if let parsedDate = formatter.date(from: dateString) {
                date = parsedDate
            } else {
                date = nil  // Handle if the date can't be parsed
            }
        } else {
            date = nil
        }
    }
}


// MARK: - Pagination
struct PaginationDetails: Codable {
    let limit, offset, count, total: Int
}


class BasicMarketStackDetailsDataService {
    func fetchDetails(urlString: String) async throws -> BasicMarketStackDetails? {
        
        if let url = URL(string: urlString) {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        }
        return nil
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> BasicMarketStackDetails? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(BasicMarketStackDetails.self, from: data)
        } catch {
            print("Error Decoding JSON: \(error)")
            return nil
        }
    }
}


class BasicMarketStackDetailsViewModel: ObservableObject {
    let tickerString: String
    @Published var tickerDetail: BasicMarketStackDetails? = nil
    
    let dataService = BasicMarketStackDetailsDataService()
    
    init(ticketString: String) {
        self.tickerString = ticketString
        
        let eodUrlString = "\(marketBaseUrl)\(marketEodEndPoint)?access_key=\(marketApiKey)&symbols=\(ticketString)&limit=1"
        
        Task {
            try await loadDetailData(urlString: eodUrlString)
        }
        
        
    }
    
    
    func loadDetailData(urlString: String) async throws {
        
        do {
            if let fetchedDetailedData = try await dataService.fetchDetails(urlString: urlString) {
                print(fetchedDetailedData)
                await MainActor.run {
                    self.tickerDetail = fetchedDetailedData
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
    }
}

struct BasicMarketStackDetailsView: View {
    
    @StateObject private var viewModel: BasicMarketStackDetailsViewModel
    
    init(tickerString: String) {
        _viewModel = StateObject(wrappedValue: BasicMarketStackDetailsViewModel(ticketString: tickerString))
    }
    
    
    var body: some View {
        ScrollView {
            if let details = viewModel.tickerDetail?.data {
                ForEach(details) { item in
                    VStack {
                        Text("Date \(String(describing: item.date))")
                        Text("Name: \(String(describing: item.name))")
                        Text("High: \(String(describing: item.high))")
                    }
                }
            }
        }
    }
}

#Preview {
    BasicMarketStackDetailsView(tickerString: "AAPL")
}
