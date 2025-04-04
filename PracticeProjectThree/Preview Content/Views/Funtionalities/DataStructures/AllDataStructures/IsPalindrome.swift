//
//  IsPalindrome.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/1/25.
//

import SwiftUI

class IsPalindromeViewModel: ObservableObject {
    @Published var isPalindome = Bool()
    
    func isPalindrome(inputValue: String) {
        let newInputValue = Array(inputValue.lowercased().filter{$0.isNumber || $0.isLetter})
        var left = 0
        var right = newInputValue.count - 1
        
        while left < right {
            if (newInputValue[left] != newInputValue[right]) {
                self.isPalindome = false
                return
            }
            
            left += 1
            right -= 1
        }
        self.isPalindome = true
    }
}

struct IsPalindrome: View {
    
    @State private var valueInput: String = ""
    @StateObject private var viewModel = IsPalindromeViewModel()
    
    var body: some View {
        VStack {
            questionView
            
            answerView
        }
    }
}

#Preview {
    IsPalindrome()
}

extension IsPalindrome {
    private var questionView: some View {
        VStack(alignment: .center) {
            Text("Is Palindrome??")
            TextField("Input Value", text: $valueInput)
                .frame(width: 280, height: 30)
                .foregroundStyle(.purple)
                .background()
                .clipShape(.capsule)
            Text("Enter")
                .frame(width: 200, height: 30)
                .foregroundStyle(.purple)
                .background()
                .clipShape(.capsule)
                .onTapGesture {
                    guard (valueInput.count > 2) else {
                        return
                    }
                    viewModel.isPalindrome(inputValue: valueInput)
                    valueInput = ""
                }
        }
        .multilineTextAlignment(.center)
        .frame(width: 300, height: 150)
        .background(.purple.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    private var answerView: some View {
        VStack {
            HStack {
                Text("Is Palindrome -- ")
                Text(viewModel.isPalindome.description.uppercased())
            }
        }
        .multilineTextAlignment(.center)
        .frame(width: 300, height: 50)
        .background(.green.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
