//
//  TripDetailsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/18/25.
//

import SwiftUI

class TripDetailsViewModel: ObservableObject {
    
    @Published var tripItem: TripItem
    
    init(tripItem: TripItem) {
        self.tripItem = tripItem
    }
    
}

struct TripDetailsView: View {
    
    @StateObject var viewModel: TripDetailsViewModel
    
    init(tripItem: TripItem) {
        _viewModel = StateObject(wrappedValue: TripDetailsViewModel(tripItem: tripItem))
    }
    
    
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.tripItem.image)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            } placeholder: {
                ProgressView()
            }
            
            Text(viewModel.tripItem.title)
            Text(viewModel.tripItem.description)
            Text(viewModel.tripItem.location)
            Text(viewModel.tripItem.startData, format: .dateTime.year().month().day())
        }
    }
}

#Preview {
    TripDetailsView(tripItem: TripItem(id: "e623e4567-e89b-12d3-a456-426614174222", title: "Trip 4", description: "Exploring the mountains", location: "Rocky Mountains", startData: Date(), endDate: Date(), image: "https://picsum.photos/400/300", isFavorite: false, isCompleted: false, isUpcoming: true))
}
