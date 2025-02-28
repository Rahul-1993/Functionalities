//
//  TripPlannerView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/18/25.
//

import SwiftUI

struct TripItem: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let location: String
    let startData: Date
    let endDate: Date
    let image: String
    let isFavorite: Bool
    let isCompleted: Bool
    let isUpcoming: Bool
    let tripImages: [String]
}

struct TripCategories: Identifiable {
    let id: String
    let categoryName: String
    let tripCategoryItems: [TripItem]
}

class TripPlannerDataService {
    func fetchTrips() -> [TripItem]? {
        guard let url = Bundle.main.url(forResource: "tripItems", withExtension: "json") else {
            print("json file not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([TripItem].self, from: data)
        } catch {
            print("error while decoding")
            return nil
        }
        
    }
}

class TripPlannerViewModel: ObservableObject {
    @Published var tripItems: [TripItem] = []
    @Published var tripCategories: [TripCategories] = []
    
    let dataService = TripPlannerDataService()
    
    init() {
        Task {
            if let trips = dataService.fetchTrips() {
                await MainActor.run {
                    self.tripItems = trips
                    categorizeTrips()
                }
            }
        }
    }
    
    func categorizeTrips() {
        self.tripCategories = [
            TripCategories(id: "1", categoryName: "Top Trips", tripCategoryItems: tripItems.filter({!$0.isUpcoming})),
            TripCategories(id: "2", categoryName: "Upcoming Trips", tripCategoryItems: tripItems.filter({$0.isUpcoming}))
        ]
    }
    
    
}

struct TripPlannerView: View {
    
    @StateObject private var viewmodel = TripPlannerViewModel()
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
                    Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
                ]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                .animation(.easeIn(duration: 1), value: animateCards)
                
                VStack {
                    if !viewmodel.tripCategories.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(viewmodel.tripCategories) { category in
                                    Text(category.categoryName)
                                        .font(.title)
                                        .foregroundStyle(.white)
                                        .offset(x: animateCards ? 0 : UIScreen.main.bounds.width)
                                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateCards)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 20) {
                                            ForEach(category.tripCategoryItems) { trip in
                                                NavigationLink {
                                                    TripDetailsView(tripItem: trip)
                                                } label: {
                                                    GeometryReader { geometry in
                                                        let minX = geometry.frame(in: .global).minX
                                                        let scale = max(0.8, 1 - abs(minX / 500))
                                                        let rotation = minX / 20
                                                        
                                                        CardView(cardItems: trip)
                                                            .scaleEffect(scale)
                                                            .rotationEffect(.degrees(rotation))
                                                            .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5).delay(0.3), value: animateCards)
                                                    }
                                                    .frame(width: 220, height: 250)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.leading)
                    } else {
                        Text("Loading trips...")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    Text("Create Trip")
                        .font(.headline)
                        .foregroundStyle(.purple)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(.capsule)
                        .padding()
                }
            }
        }
        .navigationTitle("Trip Planner")
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    animateCards = true
                }
            }
        }

    }
}

#Preview {
    TripPlannerView()
}
