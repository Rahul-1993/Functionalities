//
//  FiveTimesShowView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/11/25.
//

import SwiftUI

class FiveTimesShowViewModel: ObservableObject {
    
    @Published var textFieldChar: String = ""
    @Published var charToDisplay: String = ""
    
    private var charCount: [String: Int] = [:]
    
    func fiveTimeRepeat(_ char: String) {
        
        guard char.count == 1 else {
            return
        }
        
        charCount[char, default: 0] += 1
        
        if charCount[char] == 5 {
            self.charToDisplay = char
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.textFieldChar = ""
        }
    }
}

struct FiveTimesShowView: View {
    
    @StateObject private var viewModel = FiveTimesShowViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Five Times Repeat")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                TextField("Enter Character", text: $viewModel.textFieldChar)
                    .frame(height: 30)
                    .foregroundStyle(.purple)
                    .background(.white)
                    .clipShape(.capsule)
                    .padding()
                    .onChange(of: viewModel.textFieldChar) {
                        if viewModel.textFieldChar.count > 0 {
                            viewModel.fiveTimeRepeat(viewModel.textFieldChar)
                        }
                    }
                Text(viewModel.charToDisplay.count > 0 ? viewModel.charToDisplay : "Char Not Repeated")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(width: 250, height: 200)
            .background(.purple.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    FiveTimesShowView()
}
