//
//  SubscriptRepeatView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/10/25.
//

import SwiftUI

class SubscriptRepeatViewModel: ObservableObject {
    
    @Published var stringEnter = String()
    @Published var calculatedSubstringCount: Int = 0
    @Published var calculatedSubstring: String = ""
    
    func longestSubstring(_ s: String?) {
        
        guard let s = s,
              !s.isEmpty else {
            self.calculatedSubstring = "NA"
            self.calculatedSubstringCount = -1
            return
        }
        
        var charSet = Set<Character>()
        var left = 0, maxlength = 0
        var startIndex = 0
        let chars = Array(s)
        
        for right in 0..<chars.count {
            while charSet.contains(chars[right]) {
                charSet.remove(chars[left])
                left += 1
            }
            charSet.insert(chars[right])
            
            if right - left + 1 > maxlength {
                maxlength = right - left + 1
                startIndex = left
            }
        }
        
        let longestSub = String(chars[startIndex..<startIndex + maxlength])
        self.calculatedSubstring = longestSub
        self.calculatedSubstringCount = maxlength
    }

    
}

struct SubscriptRepeatView: View {
    
    @StateObject private var viewModel = SubscriptRepeatViewModel()
    
    var body: some View {
        ZStack {
//            RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
//                           center: .topLeading,
//                           startRadius: 5,
//                           endRadius: UIScreen.main.bounds.height)
//            .ignoresSafeArea()
            
            VStack {
                Text("Find Longest Substring")
                    .font(.title2)
                    .foregroundStyle(.white)
                TextField("String to Enter", text: $viewModel.stringEnter)
                    .font(.headline)
                    .foregroundStyle(.purple)
                    .frame(width: 300, height: 40)
                    .background()
                    .clipShape(.capsule)
                    .padding()
                Text("Enter")
                    .font(.title3)
                    .foregroundStyle(.purple)
                    .frame(width: 100, height: 40)
                    .background(.white)
                    .clipShape(.buttonBorder)
                    .onTapGesture {
                        viewModel.longestSubstring(viewModel.stringEnter)
                    }
                HStack {
                    Text(viewModel.calculatedSubstring.count > 0 ? viewModel.calculatedSubstring : "")
                        .padding()
                    Text(viewModel.calculatedSubstringCount != 0 ? String(viewModel.calculatedSubstringCount) : "")
                }
                .font(.headline)
                .foregroundStyle(.white)
            }
            .frame(width: 320, height: 250)
            .background(.purple.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
    }
}

#Preview {
    SubscriptRepeatView()
}
