//
//  VowelCountAndStringView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/1/25.
//

import SwiftUI

class VowelCountAndStringViewModel: ObservableObject {
    @Published var vowelCount: Int = 0
    @Published var vowelString: String = ""
    
    let vowelSet: Set<Character> = ["a", "e", "i", "o", "u"]
    
    func countVowelAndString( inputString: String) {
        
        for char in inputString.lowercased() {
            if vowelSet.contains(char) {
                self.vowelCount += 1
                self.vowelString.append(char)
            }
        }
    }
}

struct VowelCountAndStringView: View {
    
    @StateObject private var viewModel = VowelCountAndStringViewModel()
    @State private var stringInput: String = ""
    
    var body: some View {
        VStack {
            //Add Question View
            questionView
           // Only display answer if there are any vowel
            if viewModel.vowelCount > 0 && !viewModel.vowelString.isEmpty {
                answerView
            }
        }
    }
}

#Preview {
    VowelCountAndStringView()
}

extension VowelCountAndStringView {
    
    var questionView: some View {
        VStack(alignment: .center) {
            Text("Vowels")
                .font(.title2)
            TextField("Input String", text: $stringInput)
                .frame(width: 200, height: 30)
                .background()
                .clipShape(.capsule)
            Text("Enter")
                .frame(width: 150, height: 30)
                .font(.headline)
                .foregroundStyle(.purple)
                .background()
                .clipShape(.capsule)
                .onTapGesture {
                    viewModel.countVowelAndString(inputString: stringInput)
                    stringInput = ""
                }
        }
        .frame(width: 300, height: 200)
        .multilineTextAlignment(.center)
        .background(.purple.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
    }
    
    var answerView: some View {
        VStack {
            HStack {
                Text("Vowel Count -- ")
                Text(String(viewModel.vowelCount))
            }
            
            HStack {
                Text("Vowel String -- ")
                Text(viewModel.vowelString)
            }
        }
        .frame(width: 300, height: 100)
        .foregroundStyle(.purple)
        .background(.green.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
