//
//  PropertyWrappersView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/24/25.
//

import SwiftUI

struct PropertyWrappersList: Identifiable {
    let id: Int
    let propertyName: String
    let propertyView: AnyView
    let propertyImage: String
}

class PropertyWrappersViewModel: ObservableObject {
    let propertyList : [PropertyWrappersList] = [
        PropertyWrappersList(id: 1, propertyName: "App Storage", propertyView: AnyView(AppStorageView()), propertyImage: "swift"),
        PropertyWrappersList(id: 2, propertyName: "Environment Object", propertyView: AnyView(FirstEnvironmentView()), propertyImage: "swift")
    ]
}

struct PropertyWrappersView: View {
    
    @StateObject private var viewModel = PropertyWrappersViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading, startRadius: 5, endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                List(viewModel.propertyList) { data in
                    NavigationLink {
                        data.propertyView
                    } label: {
                        Label(data.propertyName, systemImage: data.propertyImage)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Property Wrappers")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.black)
    }
}

#Preview {
    PropertyWrappersView()
        .environmentObject(CounterViewModel())
}
