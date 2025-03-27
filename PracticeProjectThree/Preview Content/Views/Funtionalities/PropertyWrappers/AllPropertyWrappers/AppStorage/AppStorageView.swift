//
//  AppStorageView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/24/25.
//

import SwiftUI

class AppStorageViewModel: ObservableObject {
    @AppStorage("username") var username: String = "No Name"
    
    func updateUsername(newUsername: String) {
        username = newUsername
    }
}

struct AppStorageView: View {
    
    @StateObject private var viewModel = AppStorageViewModel()
    @State private var newUsernameTextField: String = ""
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading, startRadius: 5, endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                
                VStack {
                    Text("Update username")
                        .font(.title2)
                    HStack {
                        Text("Current Username --")
                            .font(.headline)
                        Text(viewModel.username)
                            .foregroundStyle(.red)
                    }
                    Text("Update Username below")
                    TextField("Update Username", text: $newUsernameTextField)
                    Button("Update") {
                        viewModel.updateUsername(newUsername: newUsernameTextField)
                        navigationPath.append("SecondAppStorageView")
                    }
                }
                .padding()
                .frame(width: 300, height: 250)
                .background()
                .foregroundStyle(.purple)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                
                .navigationDestination(for: String.self) { value in
                    if value == "SecondAppStorageView" {
                        SecondAppStorageView()
                    }
                }
            }
        }
    }
}

#Preview {
    AppStorageView()
}
