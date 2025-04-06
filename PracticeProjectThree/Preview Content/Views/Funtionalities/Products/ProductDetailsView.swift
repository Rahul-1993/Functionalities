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
    
}

struct ProductDetailsView: View {
    
    @StateObject var viewModel: ProductDetailsViewModel
    
    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(product: product))
    }
    
    
    var body: some View {
        HStack {
            Text(viewModel.product.title)
            Text(String(viewModel.product.price))
        }
        
    }
}

#Preview {
    
    let category = Category(id: 1, name: "some", slug: "some", image: "", creationAt: Date(), updatedAt: Date())
    let product = Product(id: 1, title: "some", slug: "some", price: 10, description: "some", category: category, images: ["https://i.imgur.com/QkIa5tT.jpeg"], creationAt: Date(), updatedAt: Date())
    
    ProductDetailsView(product: product)
}
