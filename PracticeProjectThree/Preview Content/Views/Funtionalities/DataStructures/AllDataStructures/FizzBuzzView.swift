//
//  FizzBuzzView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/4/25.
//

import SwiftUI

class FizzBuzzViewModel: ObservableObject {
    @Published var outputArray: [String] = []
    
    func fizzBuzz(inputInteger: Int) {
        
        var localOutputArray : [String] = ["1", "2"]
        
        for i in 3...inputInteger {
            if (i % 3 == 0 && i % 5 == 0) {
                localOutputArray.append("FizzBuzz")
            } else if (i % 3 == 0) {
                localOutputArray.append("Fizz")
            } else if (i % 5 == 0) {
                localOutputArray.append("Buzz")
            } else {
                localOutputArray.append(String(i))
            }
        }
        print(localOutputArray)
        self.outputArray = localOutputArray
    }
    
    func fizzBuzzSwitch(inputInteger: Int) {
        
        var localOutputArray : [String] = ["1", "2"]
        
        for num in 3...inputInteger {
            switch (num % 3, num % 5) {
            case (0, 0) : localOutputArray.append("FizzBuzz")
            case (0, _) : localOutputArray.append("Fizz")
            case (_, 0) : localOutputArray.append("Buzz")
            default: localOutputArray.append(String(num))
            }
        }
        self.outputArray = localOutputArray
    }
}

struct FizzBuzzView: View {
    
    @StateObject private var viewModel = FizzBuzzViewModel()
    @State private var inputValue = String()
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Fizz Buzz")
            TextField("Input Value", text: $inputValue)
            Text("Enter")
                .onTapGesture {
                    if let input = Int(inputValue) {
                        viewModel.fizzBuzzSwitch(inputInteger: input)
                    }
                }
            if viewModel.outputArray.count > 1 {
                List(viewModel.outputArray, id: \.self) { data in
                    Text(data)
                }
            }

        }
    }
}

#Preview {
    FizzBuzzView()
}
