//
//  PracticeProjectThreeApp.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/17/25.
//

import SwiftUI

@main
struct PracticeProjectThreeApp: App {
    
    @StateObject private var counterViewModel = CounterViewModel()
    
    var body: some Scene {
        WindowGroup {
            IntroView()
                .environmentObject(counterViewModel)
        }
    }
}
