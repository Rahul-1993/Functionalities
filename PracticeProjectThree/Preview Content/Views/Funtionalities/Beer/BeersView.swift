//
//  BeersView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/21/25.
//

import SwiftUI

struct BeerType: Identifiable {
    let id: Int
    let beerType: String
    let url: String
}

struct BeersView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil)
    ]
    
    let beerType: [BeerType] = [
        BeerType(id: 1, beerType: "Ale", url: "https://api.sampleapis.com/beers/ale"),
        BeerType(id: 2, beerType: "Stout", url: "https://api.sampleapis.com/beers/stouts"),
        BeerType(id: 3, beerType: "Red-Ale", url: "https://api.sampleapis.com/beers/red-ale")
    ]
    
    @State private var selectedUrl: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                
                LazyVGrid(columns: columns, alignment: .center, spacing: 30, pinnedViews: []) {
                    ForEach(beerType) { beer in
                        Button {
                            selectedUrl = beer.url
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.white)
                                    .frame(width: 250, height: 200)
                                
                                Text(beer.beerType)
                            }
                        }

                        }

                    }
                }
                
            }
            .navigationTitle("Beer Types")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: Binding(
                get: { selectedUrl != nil },
                set: { if !$0 { selectedUrl = nil } }
            )) {
                if let url = selectedUrl {
                    BeerDetailsView(value: url)
                }
            }
        }

    }


#Preview {
    BeersView()
}
