//
//  WeatherDetailsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/19/25.
//

import SwiftUI

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherCondition: Codable {
    let icon: String
    let description: String
}

class WeatherDetailDataService {
    
    let genericDataService = GenericDataService()
    
    func genericFetchWeatherData(url: URL) async -> Weather? {
        await genericDataService.fetchData(from: url)
    }
    func fetchWeatherData(url: String) async -> Weather? {
        guard
            let url = URL(string: url) else {
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let returnedData = handleResponse(data: data, response: response)
            return returnedData
        } catch {
            print("Error")
            return nil
        }
        
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> Weather? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        
        let returnedData = try? JSONDecoder().decode(Weather.self, from: data)
        return returnedData

    }
}

class WeatherDetailsViewModel: ObservableObject {
    
    @Published var weatherDetails : Weather?
    let dataService = WeatherDetailDataService()
    
    let city: String
    
    init(city: String)  {
        self.city = city
        Task {
            await genericLoadWeatherData()
        }

    }
    
    func genericLoadWeatherData() async {
        if let url = URL(string: "\(baseUrl)\(version)\(endPoint)?q=\(city)&appid=\(apiKey)&units=\(units)") {
            if let data = await dataService.genericFetchWeatherData(url: url) {
                await MainActor.run {
                    self.weatherDetails = data
                }
            }
        }
        
    }
    
    func loadWeatherData() async {
        let urlString = "\(baseUrl)\(version)\(endPoint)?q=\(city)&appid=\(apiKey)&units=\(units)"
        let returnedData = await dataService.fetchWeatherData(url: urlString)
        await MainActor.run {
            self.weatherDetails = returnedData
        }
    }
}

struct WeatherDetailsView: View {
    
    @StateObject var viewModel : WeatherDetailsViewModel
    
    init(city: String) {
        _viewModel = StateObject(wrappedValue: WeatherDetailsViewModel(city: city))
    }
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                           center: .topLeading,
                           startRadius: 5,
                           endRadius: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                
                if let weather = viewModel.weatherDetails {
                    VStack {
                        Text(weather.name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                        if let icon = weather.weather.first?.icon {
                            let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                            AsyncImage(url: iconUrl) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                            } placeholder: {
                                ProgressView()
                            }
                                
                        }
                        
                        Text("Description: \(weather.weather.first?.description.capitalized ?? "")")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                        Text("Temperature: \(String(format: "%.1f", weather.main.temp)) C")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                        Text("Humidity: \(String(weather.main.humidity))")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.purple)
                    }
                }
            }
            .frame(width: 400, height: 350)
                
            
            
        }
    }
}

#Preview {
    WeatherDetailsView(city: "Mumbai")
}
