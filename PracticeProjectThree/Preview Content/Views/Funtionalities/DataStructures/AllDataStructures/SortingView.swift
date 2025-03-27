//
//  SortingView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/26/25.
//

import SwiftUI

class SortingViewModel: ObservableObject {
    var inputArray: [Int] = []
    @Published var sortedArray: [Int] = []
    
    func addElementToArray(number: Int) {
        
        self.inputArray.append(number)
        
    }
    
    func sortHigherOrder() {
        if inputArray.count > 1 {
            self.sortedArray = inputArray.sorted()
        }
    }
    
    func sortBubbleSort() {
        var sortArray: [Int] = inputArray
        let count = sortArray.count - 1
        
        for i in 0...count {
            for j in 0..<count - i {
                if sortArray[j + 1] < sortArray[j] {
                    sortArray.swapAt(j, j+1)
//                    let temp = sortArray[j]
//                    sortArray[j] = sortArray[j+1]
//                    sortArray[j+1] = temp
                }
            }
        }
        self.sortedArray = sortArray
    }
    
    func printArray() {
        print("printing ----")
        for num in self.inputArray {
            print(num, separator: ",")
        }
    }
    
    
}

struct SortingView: View {
    
    @StateObject private var viewModel = SortingViewModel()
    @State var inputElement = String()
    
    var body: some View {
            VStack {
                ZStack {
                    RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                                   center: .topLeading, startRadius: 5, endRadius: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                    VStack(alignment: .center) {
                        Text("Sorting")
                            .font(.title2)
                        Text("Input individual elements without spaces")
                            .font(.headline)
                        TextField("Input", text: $inputElement)
                            .frame(width: 60, height: 40)
                            .foregroundStyle(.purple.opacity(0.8))
                            .background()
                            .clipShape(.capsule)
                        Text("Enter")
                            .frame(width: 250, height: 30)
                            .foregroundStyle(.purple)
                            .background()
                            .clipShape(.capsule)
                            .onTapGesture {
                                if let num = Int(inputElement) {
                                    inputElement = ""
                                    viewModel.addElementToArray(number: num)
                                }
                            }
                        Text("Sort (Higher Order)")
                            .frame(width: 250, height: 30)
                            .foregroundStyle(.purple)
                            .background()
                            .clipShape(.capsule)
                            .onTapGesture {
                                viewModel.sortHigherOrder()
                            }
                        
                        Text("Sort (Bubble Sort)")
                            .frame(width: 250, height: 30)
                            .foregroundStyle(.purple)
                            .background()
                            .clipShape(.capsule)
                            .onTapGesture {
                                viewModel.sortBubbleSort()
                            }
                        
                        Text("Print")
                            .frame(width: 250, height: 30)
                            .foregroundStyle(.purple)
                            .background()
                            .clipShape(.capsule)
                            .onTapGesture {
                                viewModel.printArray()
                            }
                    }
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                }
            }
            .frame(width: 300, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        
        if viewModel.sortedArray.count > 1 {
            answerView
        }
    }
}

#Preview {
    SortingView()
}

extension SortingView {
    private var answerView: some View {
        VStack {
            let sorted = viewModel.sortedArray.map { String($0) }
            Text(sorted.joined(separator: " - "))
        }
        .frame(width: 300, height: 100)
        .background(.green.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
