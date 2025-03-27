//
//  TwoSumView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/27/25.
//

import SwiftUI

class TwoSumViewModel: ObservableObject {
    @Published var result: [Int] = []
    
    var inputArray: [Int] = []
    
    func insertElement(element: Int) {
        self.inputArray.append(element)
    }
    
    func twoSum(answer: Int) {
        guard self.inputArray.count > 2 else {
            return
        }
        
        let array = self.inputArray.sorted()
        printArray(array: array)
        var left = 0
        var right = array.count - 1
        
        while left < right {
            let sum = array[left] + array[right]
            
            if answer == sum {
                self.result = [left + 1, right + 1]
                return
            } else if answer < sum {
                right -= 1
            } else {
                left += 1
            }
        }
        self.result = [-1]
        return
    }
    
    func printArray(array: [Int]) {
        print("printing Sorted array")
        for num in array {
            print(num, separator: " - ")
        }
    }
}

struct TwoSumView: View {
    
    @StateObject private var viewModel = TwoSumViewModel()
    
    @State private var element: String = ""
    @State private var target: String = ""
    
    var body: some View {
        
        VStack(alignment: .center) {
            VStack(alignment: .center) {
                Text("Two Sum")
                Text("Enter Elements")
                TextField("Element", text: $element)
                    .frame(width: 70, height: 40)
                    .background()
                    .clipShape(.capsule)
                Text("Insert")
                    .frame(width: 250, height: 35)
                    .foregroundStyle(.purple)
                    .background()
                    .clipShape(.capsule)
                    .onTapGesture {
                        if let insertIntElement = Int(element) {
                            element = ""
                            viewModel.insertElement(element: insertIntElement)
                        }
                    }
            }
            .frame(width: 300, height: 200)
            .multilineTextAlignment(.center)
            .background(.purple.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            VStack(alignment: .center) {
                Text("Solve for Two Sum")
                TextField("Target", text: $target)
                    .frame(width: 70, height: 40)
                    .foregroundStyle(.purple)
                    .background()
                    .clipShape(.capsule)
                Text("Two Sum")
                    .frame(width: 250, height: 35)
                    .foregroundStyle(.purple)
                    .background()
                    .clipShape(.capsule)
                    .onTapGesture {
                        if let targetElement = Int(target) {
                            target = ""
                            viewModel.twoSum(answer: targetElement)
                        }
                    }
            }
            .frame(width: 300, height: 170)
            .multilineTextAlignment(.center)
            .background(.purple.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            if viewModel.result.count > 0 {
                HStack(alignment: .center) {
                    Text("Target --")
                    
                    let stringAnswer = viewModel.result.map({String($0)})
                    
                    Text(stringAnswer.first == "-1" ? "Target not found" : stringAnswer.joined(separator: " - "))

                }
                .frame(width: 300, height: 60)
                .foregroundStyle(.black)
                .background(.green.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }

    }
}

#Preview {
    TwoSumView()
}
