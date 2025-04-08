//
//  ThirdEnvironmentView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import SwiftUI

struct ThirdEnvironmentView: View {
    
    @EnvironmentObject var counterViewModel : CounterViewModel
    
    var body: some View {
        Text(String(counterViewModel.count))
    }
}

#Preview {
    ThirdEnvironmentView()
        .environmentObject(CounterViewModel())
}
