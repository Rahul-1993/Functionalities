//
//  FirstNonRecurringElementView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/10/25.
//

import SwiftUI

class FirstNonRecurringElementViewModel: ObservableObject {
    
    @Published var element: String = ""
    
    func firstNonRecurringElementFunction(stringInput: String) {
        var stringArray = Array(stringInput.lowercased())
        let count = stringArray.count - 1
        
        for i in 0..<count {
            let currentElement = stringArray[i]
            var localArray = stringArray
            localArray.remove(at: i)
            if !localArray.contains(currentElement) {
                self.element = String(currentElement)
                return
            }
        }
    }
    
    
}

struct FirstNonRecurringElementView: View {
    
    @StateObject private var viewModel = FirstNonRecurringElementViewModel()
    
    @State private var inputString = ""
    
    var body: some View {
        TextField("Input String", text: $inputString)
        Button("Enter") {
            viewModel.firstNonRecurringElementFunction(stringInput: inputString)
        }
        
        if viewModel.element.count > 0 {
            Text(viewModel.element)
        }
    }
}

#Preview {
    FirstNonRecurringElementView()
}
