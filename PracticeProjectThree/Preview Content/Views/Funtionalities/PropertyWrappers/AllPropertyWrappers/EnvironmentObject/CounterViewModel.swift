//
//  CounterViewModel.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import Foundation
import SwiftUI

class CounterViewModel: ObservableObject {
    @Published var count = 0
    
    func incrementCount() {
        self.count += 1
    }
    
    func decrementCount() {
        self.count -= 1
    }
    
    func resetCount() {
        self.count = 0
    }
}
