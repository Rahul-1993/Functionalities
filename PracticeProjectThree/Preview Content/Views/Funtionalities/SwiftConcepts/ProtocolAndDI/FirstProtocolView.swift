//
//  FirstProtocolView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import SwiftUI

class FirstProtocolViewModel: ObservableObject {
    let service: WeatherService
    
    init(service: WeatherService = LiveWeatherDataService()) {
        self.service = service
    }
}

struct FirstProtocolView: View {
    
    @StateObject private var viewModel = FirstProtocolViewModel()
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                ProtocolsAndDIView(service: viewModel.service)
            } label: {
                Label("Go to Weather View", systemImage: "cloud")
            }

        }
    }
}

#Preview {
    FirstProtocolView()
}
