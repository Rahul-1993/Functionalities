//
//  ProtocolsAndDIView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import SwiftUI

protocol WeatherService {
    func getDataInCelcius() -> String
    func getDataInFarenheit() -> String
}

class MockWeatherDataService: WeatherService {
    func getDataInCelcius() -> String {
        return "Mock Data in celcius"
    }
    
    func getDataInFarenheit() -> String {
        return "Mock Data in farenheit"
    }
}

class LiveWeatherDataService: WeatherService {
    func getDataInCelcius() -> String {
        return "22 C"
    }
    
    func getDataInFarenheit() -> String {
        return "63 F"
    }
    
}

class ProtocolsAndDIViewModel: ObservableObject {
    @Published var weatherData: String = ""
    @Published var metric: Bool = false
    
    let service: WeatherService
    
    init(service: WeatherService) {
        self.service = service
        
        getWeather()
    }
    
    func getWeather() {
        switch metric {
        case false : self.weatherData = service.getDataInCelcius()
        case true : self.weatherData = service.getDataInFarenheit()
        }
    }
}

struct ProtocolsAndDIView: View {
    
    @StateObject private var viewModel: ProtocolsAndDIViewModel
    @State private var metricTracker: Bool = false
    
    init(service: WeatherService) {
        _viewModel = StateObject(wrappedValue: ProtocolsAndDIViewModel(service: service))
    }
    
    var body: some View {
        
        Toggle("Toggle", isOn: $viewModel.metric)
            .onChange(of: viewModel.metric) { newValue, oldValue in
                viewModel.getWeather()
            }
        
        Text(viewModel.weatherData)
    }
}

#Preview {
    let service = LiveWeatherDataService()
    ProtocolsAndDIView(service: service)
}
