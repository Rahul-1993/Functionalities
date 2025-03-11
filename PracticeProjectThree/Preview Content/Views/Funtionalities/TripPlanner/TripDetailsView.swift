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
    @State private var currentIndex = 0
    
    init(tripItem: TripItem) {
        _viewModel = StateObject(wrappedValue: TripDetailsViewModel(tripItem: tripItem))
    }
    
    
    
    var body: some View {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height).opacity(0.4)
                .ignoresSafeArea()
                
                VStack {
                    imageView
                        .padding(.bottom)
                    

                    tripDetailsView
                    
                    
                    Spacer()
                    
                }
            }
    }
}


#Preview {
    TripDetailsView(tripItem: TripItem(id: "e623e4567-e89b-12d3-a456-426614174222", title: "Trip 4", description: "Exploring the mountains", location: "Rocky Mountains", startData: Date(), endDate: Date(), image: "https://picsum.photos/400/300", isFavorite: false, isCompleted: false, isUpcoming: true, tripImages: ["https://picsum.photos/200/310", "https://picsum.photos/200/310", "https://picsum.photos/200/310", "https://picsum.photos/200/310"]))
}

extension TripDetailsView {
    private var imageView : some View {
        VStack {
            TabView(selection: $currentIndex) {
                if viewModel.tripItem.tripImages.count > 0 {
                    ForEach(Array(viewModel.tripItem.tripImages.indices), id: \.self) { index in
                        AsyncImage(url: URL(string: viewModel.tripItem.image)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 100))
                        } placeholder: {
                            ProgressView()
                        }
                        .tag(index)
                    }
                }
                    
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .frame(height: 350)
    }
    
    private var tripDetailsView: some View {
        VStack {
            Text(viewModel.tripItem.title)
            Text(viewModel.tripItem.description)
            Text(viewModel.tripItem.location)
            Text(viewModel.tripItem.startData, format: .dateTime.year().month().day())
        }
    }
}

