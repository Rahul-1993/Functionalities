//
//  ProductsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/5/25.
//

import SwiftUI

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let slug: String
    let price: Int
    let description: String
    let category: Category
    let images: [String]
    let creationAt: Date
    let updatedAt: Date
}

struct Category: Codable {
    let id: Int
    let name: String
    let slug: String
    let image: String
    let creationAt: Date
    let updatedAt: Date
}

class ProductDataService {
    
    func getProductData() async throws -> [Product]?{
        let url = URL(string: productUrl)
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url!)
            return handleResponse(data: data, response: response)
        } catch {
            print("Error making the api call")
            return nil
        }
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> [Product]? {
        
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            let returnedData = try decoder.decode([Product].self, from: data)
            return returnedData
        } catch  {
            print("Error decoding data")
            return nil
        }
    }
    
}

class ProductsViewModel: ObservableObject {
    
    @Published var productArray: [Product] = []
    
    let dataService = ProductDataService()
    
    init() {
        Task {
            await fetchProductData()
        }
    }
    
    
    func fetchProductData() async {
        let returnedData = try? await dataService.getProductData()
        
        if let data = returnedData {
            await MainActor.run {
                self.productArray = data
            }
        }
    }
    
    
}

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    let column: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: .center),
        GridItem(.flexible(), spacing: nil, alignment: .center)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: column, alignment: .center, spacing: nil, pinnedViews: []) {
                    ForEach(viewModel.productArray) { data in
                        
                        NavigationLink {
                            ProductDetailsView(product: data)
                        } label: {
                            VStack {
                                if let imageUrl = URL(string: data.images.first!) {
                                    AsyncImage(url: imageUrl) { image in
                                        image.image?.resizable()
                                            .scaledToFit()
                                            .frame(height: 120)
                                    }
                                }
                                HStack {
                                    Text(data.title)
                                    Text(String(data.price))
                                }
                                .foregroundStyle(.black)
                            }
                            .frame(width: 190, height: 200)
                            .background(.black.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                    }
                }
            }
        }
        

        

    }
}

#Preview {
    ProductsView()
}
