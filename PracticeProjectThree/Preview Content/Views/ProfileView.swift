//
//  ProfileView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/17/25.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @AppStorage("signed_In") var currentUserSignedIn: Bool = false
    @AppStorage("current_user") var currentUserName: String?
    @AppStorage("current_age") var currentUserAge: Int?
    @AppStorage("current_gender") var currentUserGender: String?
    
    func signOut() {
        currentUserAge = nil
        currentUserName = nil
        currentUserGender = nil
        currentUserSignedIn.toggle()
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    

    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.white)
                    Text(viewModel.currentUserName ?? "Your Name")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Text(String(viewModel.currentUserAge ?? 0))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Text(viewModel.currentUserGender ?? "Your Gender")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    NavigationLink {
                        FunctionalitiesView()
                    } label: {
                        Text("Functionalities")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(width: 150, height: 40)
                            .foregroundStyle(.purple)
                            .background(.white)
                            .clipShape(.capsule)
                            .padding(.top, 50)
                    }
                    Text("SIGN OUT")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.purple)
                        .background(.white)
                        .clipShape(.capsule)
                        .onTapGesture {
                            viewModel.signOut()
                        }
                }
                .padding()
            }
        }
        .tint(.black)
    }
}

#Preview {
    ProfileView()
}
