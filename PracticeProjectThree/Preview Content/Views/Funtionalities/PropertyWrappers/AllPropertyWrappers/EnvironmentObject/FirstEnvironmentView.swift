//
//  FirstEnvironmentView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import SwiftUI

struct FirstEnvironmentView: View {
    
    @EnvironmentObject var counterViewModel : CounterViewModel
    
    var body: some View {
        NavigationStack {
            
            Text(String(counterViewModel.count))
            
            Button("Increase Counter") {
                counterViewModel.incrementCount()
            }
            
            Button("Decrease Count") {
                counterViewModel.decrementCount()
            }
            
            Button("Reset Count") {
                counterViewModel.resetCount()
            }
            
            NavigationLink {
                SecondEnvironmentView()
            } label: {
                Text("Go to 2nd view")
            }

        }
    }
}

#Preview {
    FirstEnvironmentView()
        .environmentObject(CounterViewModel())
}
