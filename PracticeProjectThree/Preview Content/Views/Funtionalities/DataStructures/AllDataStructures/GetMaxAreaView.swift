//
//  GetMaxAreaView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/27/25.
//

import SwiftUI

class GetMaxAreaViewModel: ObservableObject {
    
    @Published var maxArea: Int = 0
    
    var inputArray: [Int] = []
    
    func addElement(value: Int) {
        self.inputArray.append(value)
    }
    
    func printUnsortedArray() {
        print("Unsorted Array")
        for num in inputArray {
            print(num, separator: ",")
        }
    }
    
    func getMaxArea() {
        guard inputArray.count > 2 else {
            return
        }
        
        let array = self.inputArray
        var left = 0
        var right = self.inputArray.count - 1
        var maxArea : Int = 0
        while left < right {
            let minHeight = min(array[left], array[right])
            let area = minHeight * (right - left)
            maxArea = max(area, maxArea)
            
            array[left] < array[right] ? (left += 1) : (right -= 1)
        }
        self.maxArea = maxArea
    }
    
}

struct GetMaxAreaView: View {
    
    @StateObject private var viewModel = GetMaxAreaViewModel()
    
    @State private var inputElement: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading, startRadius: 5, endRadius: UIScreen.main.bounds.height)
                
                VStack(alignment: .center) {
                    Text("Get Max Area")
                    Text("Enter Elements")
                    TextField("Input Element", text: $inputElement)
                        .frame(width: 80, height: 40)
                        .foregroundStyle(.purple)
                        .background()
                        .clipShape(.capsule)
                    Text("Enter")
                        .frame(width: 250, height: 30)
                        .foregroundStyle(.purple)
                        .background()
                        .clipShape(.capsule)
                        .onTapGesture {
                            if let value = Int(inputElement) {
                                inputElement = ""
                                viewModel.addElement(value: value)
                            }
                        }
                    Text("Print Unsorted Array")
                        .frame(width: 250, height: 30)
                        .foregroundStyle(.purple)
                        .background()
                        .clipShape(.capsule)
                        .onTapGesture {
                            viewModel.printUnsortedArray()
                        }
                    Text("Max Area")
                        .frame(width: 250, height: 30)
                        .foregroundStyle(.purple)
                        .background()
                        .clipShape(.capsule)
                        .onTapGesture {
                            viewModel.getMaxArea()
                        }
                }
            }
            
        }
        .multilineTextAlignment(.center)
        .frame(width: 300, height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
        if viewModel.maxArea > 0 {
            answerView
        }
        
    }
}

#Preview {
    GetMaxAreaView()
}

extension GetMaxAreaView {
    private var answerView: some View {
        HStack {
            Text("Max Area")
            Text(String(viewModel.maxArea))
        }
        .frame(width: 300, height: 70)
        .background(.green.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
