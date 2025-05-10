//
//  ReverseStringView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 5/10/25.
//

import SwiftUI

class ReverseStringViewModel: ObservableObject {
    
    @Published var reversedString = ""
    
    func reverseString(inputString: String) {
        var inputArray = Array(inputString)
        var left = 0
        var right = inputArray.count - 1
        
        while left < right {
            inputArray.swapAt(left, right)
            left += 1
            right -= 1
        }
        self.reversedString = String(inputArray)
    }
    
}

struct ReverseStringView: View {
    
    @StateObject var viewModel = ReverseStringViewModel()
    @State var stringInput = ""
    
    var body: some View {
        ZStack {
            
            VStack {
                GroupBox("Reverse String") {
                    VStack {
                        Text("Enter String to reverse Below")
                        TextField("Enter String", text: $stringInput)
                            .frame(width: 100)
                        Button {
                            guard stringInput.count > 1 else {
                                return
                            }
                            viewModel.reverseString(inputString: stringInput)
                        } label: {
                            Label("Enter", systemImage: "car.fill")
                        }
                    }
                }
                .padding(.horizontal)
                
                GroupBox("Answer") {
                    VStack {
                        Text("\(viewModel.reversedString)")
                    }
                }
                .padding(.horizontal)
            }
            .multilineTextAlignment(.center)

        }
    }
}

#Preview {
    ReverseStringView()
}
