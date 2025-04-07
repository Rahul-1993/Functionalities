//
//  ProductDetailsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/5/25.
//

import SwiftUI

class ProductDetailsViewModel: ObservableObject {
    
    let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    func loadProductFromUserDefaults() -> [Product] {
        guard let savedData = UserDefaults.standard.data(forKey: "myProducts"),
              let decoded = try? JSONDecoder().decode([Product].self, from: savedData) else {
            return []
        }
        
        return decoded
    }
    
}

struct ProductDetailsView: View {
    
    @StateObject var viewModel: ProductDetailsViewModel
    
    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(product: product))
        
    }
    
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text(viewModel.product.category.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.leading)
                    .padding(.top)
                
                HStack {
                    if let imageUrl = URL(string: viewModel.product.images.first ?? "https://picsum.photos/200/300") {
                        AsyncImage(url: imageUrl) { image in
                            image.image?.resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .padding()
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(viewModel.product.title)
                            .font(.title)
                        HStack {
                            Text(String(viewModel.product.price + 4))
                            Text("\(String(viewModel.product.price))$")
                        }
                        .font(.headline)
                        Text(viewModel.product.description)
                        
                        
                    }
                }
                .frame(height: 240)
                
                VStack(alignment: .center) {
                    Text("Buy worth \(viewModel.product.price)$")
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                        .multilineTextAlignment(.center)
                        .background(.yellow.opacity(0.4))
                        .clipShape(.capsule)
                }
                .padding(.horizontal)
                
                    ScrollView(.horizontal) {
                        LazyHStack {
                            let products = viewModel.loadProductFromUserDefaults().filter({$0.category.name == viewModel.product.category.name})
                            ForEach(products) { data in
                                NavigationLink {
                                    ProductDetailsView(product: data)
                                } label: {
                                    VStack {
                                        if let imageUrl = URL(string: data.images.first ?? "https://picsum.photos/200/300") {
                                            AsyncImage(url: imageUrl) { image in
                                                image.image?.resizable()
                                                    .scaledToFit()
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                        }
                                        Text(data.title)
                                    }
                                    .frame(width: 150, height: 150)
                                    .foregroundStyle(.blue)
                                }
                            }
                        }
                    }
                
            }
        }

        
        

        
    }
}

#Preview {
    
    let category = Category(id: 1, name: "Clothes", slug: "some", image: "", creationAt: Date(), updatedAt: Date())
    let product = Product(id: 1, title: "some", slug: "some", price: 10, description: "some", category: category, images: ["https://i.imgur.com/QkIa5tT.jpeg"], creationAt: Date(), updatedAt: Date())
    
    ProductDetailsView(product: product)
}
