//
//  WeatherView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/17/25.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
}

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                
                VStack {
                    Spacer()
                    
                    Text("Weather Info")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    HStack {
                        TextField("Enter a city name", text: $viewModel.city)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background()
                            .clipShape(.capsule)
                        NavigationLink {
                            WeatherDetailsView(city: "mumbai")
                        } label: {
                            Image(systemName: "location")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.purple)
                                .frame(width: 60, height: 50)
                                .background()
                                .clipShape(.capsule)
                        }
                    }
                    .padding()
                    
                    NavigationLink {
                        WeatherDetailsView(city: viewModel.city)
                    } label: {
                        Text("Search")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.purple)
                            .background()
                            .clipShape(.capsule)
                            .padding()
                    }
                    
                    Spacer()
                    Spacer()
                }

            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
        }

        
    }
}

#Preview {
    WeatherView()
}
