//
//  BeerDetailsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/21/25.
//

import SwiftUI

struct Beer: Identifiable, Codable {
    let price, name: String
    let rating: Rating
    let image: String
    let id: Int
}

struct Rating: Codable {
    let average: Double
    let reviews: Int
}

class BeerDataService {
    func fetchData (url: URL) async -> [Beer]? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let returnedData = handleResponse(data: data, response: response)
            return returnedData
        } catch {
            print("Error")
            return nil
        }
        
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> [Beer]? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        
        let returnedData = try? JSONDecoder().decode([Beer].self, from: data)
        return returnedData
    }
}

class BeerDetailsViewModel: ObservableObject {
    let value: String
    
    init(value: String){
        self.value = value
        
        Task {
            await getData(urlString: value)
        }
    }
    
    @Published var dataArray: [Beer] = []
    let dataService = BeerDataService()
    
    func getData(urlString: String) async {
        if let url = URL(string: urlString) {
            if let returnedData = await dataService.fetchData(url: url) {
                await MainActor.run {
                    self.dataArray = returnedData
                }
            }
        }
    }
    
}

struct BeerDetailsView: View {
    @StateObject private var viewModel: BeerDetailsViewModel
    @State private var selectedBeer: Beer? = nil
    
    init(value: String) {
        _viewModel = StateObject(wrappedValue: BeerDetailsViewModel(value: value))
    }
    
    var body: some View {
        
        let columns: [GridItem] = [
            GridItem(.flexible(), spacing: nil, alignment: .center),
            GridItem(.flexible(), spacing: nil, alignment: .center)
        ]
        
        ScrollView {
            ZStack {
                
                Color.white
                    .ignoresSafeArea()
                
            
                LazyVGrid(columns: columns, alignment: .center, spacing: nil, pinnedViews: []) {
                    ForEach(viewModel.dataArray) { beer in
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.purple)
                            if let url = URL(string: beer.image) {
                                AsyncImage(url: url)
                                    .luminanceToAlpha()
                            }
                            VStack(spacing: 10) {
                                HStack(alignment: .center) {
                                    Text(beer.name)
                                    Text(beer.price)
                                }
                                Text("Rating - \(String(format: "%.1f", beer.rating.average))")
                            }
                            .popover(item: $selectedBeer, content: { beer in
                                Text(beer.name)
                                    .presentationCompactAdaptation(.popover)
                            })
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                        }
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            selectedBeer = beer
                        }
                    }
                    
                }
            }
        }

        .padding()
        

    

        
    }
}

#Preview {
    BeerDetailsView(value: "https://api.sampleapis.com/beers/ale")
}
