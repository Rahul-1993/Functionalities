//
//  BasicAsyncAwaitView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 6/14/25.
//

import SwiftUI

@Observable
class BasicAsyncAwaitViewModel {
    
//    init() {
//        Task {
//            await processWeather()
//        }
//    }
    
    func fetchWeatherHistory() async -> [Double] {
        (1...100_000).map { _ in Double.random(in: -10...30) }
    }
    
    func calculateAverageTemperature(for records: [Double]) async -> Double {
        let total = records.reduce(0, +)
        let average = total / Double(records.count)
        return average
    }
    
    func upload(result: Double) async -> String {
        "OK"
    }
    
    func processWeather() async {
        let records = await fetchWeatherHistory()
        let average = await calculateAverageTemperature(for: records)
        let response = await upload(result: average)
        print(average)
        print(response)
    }
    
}

struct BasicAsyncAwaitView: View {
    
    @State private var viewModel: BasicAsyncAwaitViewModel
    
    init() {
        _viewModel = State(wrappedValue: BasicAsyncAwaitViewModel())
    }
    
    var body: some View {
        Button {
            Task {
                await viewModel.processWeather()
            }
        } label: {
            Text("Enter")
        }

    }
}

#Preview {
    BasicAsyncAwaitView()
}
