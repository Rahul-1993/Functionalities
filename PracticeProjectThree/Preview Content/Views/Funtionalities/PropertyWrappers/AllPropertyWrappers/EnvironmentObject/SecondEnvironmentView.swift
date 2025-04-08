//
//  SecondEnvironmentView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import SwiftUI

struct SecondEnvironmentView: View {
    
    @EnvironmentObject var counterViewModel: CounterViewModel
    
    var body: some View {
        NavigationStack {
            Text(String(counterViewModel.count))
            Button("Increment") {
                counterViewModel.incrementCount()
            }
            
            Button("Decrement") {
                counterViewModel.decrementCount()
            }
            
            Button("Reset") {
                counterViewModel.resetCount()
            }
            
            NavigationLink {
                ThirdEnvironmentView()
            } label: {
                Label("Go to 3rd view", systemImage: "car")
            }

        }
    }
}

#Preview {
    SecondEnvironmentView()
        .environmentObject(CounterViewModel())
}
