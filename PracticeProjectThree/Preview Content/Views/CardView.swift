//
//  CardView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/18/25.
//

import SwiftUI

class CardViewModel: ObservableObject {
    
}

struct CardView: View {
    
    @StateObject private var viewModel = CardViewModel()
    
    let cardItems: TripItem
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: cardItems.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 200, height: 200)
            }
            
            Text(cardItems.title)
            Text(cardItems.description)
            !cardItems.isUpcoming ? Text(cardItems.location) : Text(cardItems.startData, format: .dateTime.year().month().day())
                
            
        }
        .frame(width: 200, height: 250)
        .background(.black.opacity(0.6))
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

#Preview {
    ZStack {
        Color.purple
            .ignoresSafeArea()
        
        CardView(cardItems: TripItem(id: "1", title: "Trip Item", description: "Trip Description", location: "Mumbai, India", startData: Date(), endDate: Date(), image: "https://picsum.photos/200/310", isFavorite: true, isCompleted: false, isUpcoming: true))
    }
}
