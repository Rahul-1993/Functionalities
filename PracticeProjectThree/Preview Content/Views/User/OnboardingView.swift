//
//  OnboardingView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/17/25.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    
    @Published var onBoardingState: Int = 0
    
    @Published var name: String = ""
    @Published var age: Double = 50
    @Published var gender: String = ""
    
    @Published var alertTitle: String = ""
    @Published var showAlert: Bool = false
    
    @AppStorage("signed_In") var currentUserSignedIn: Bool = false
    @AppStorage("current_user") var currentUserName: String?
    @AppStorage("current_age") var currentUserAge: Int?
    @AppStorage("current_gender") var currentUserGender: String?
    
    func handleButtonButton() {
        switch onBoardingState {
        case 1:
            guard name.count > 3 else {
                alertDisplayed(title: "Name should be more than 3 characters..😓")
                return
            }
        case 3:
            guard gender.count > 3 else {
                alertDisplayed(title: "Please select a gender from the options displayed..")
                return
            }
            
        default:
            break
        }
        
        onBoardingState == 3 ? signIn() : (onBoardingState += 1)
    }
    
    func alertDisplayed(title: String) {
        alertTitle = title
        showAlert.toggle()
    }
    
    func signIn() {
        currentUserName = name
        currentUserAge = Int(age)
        currentUserGender = gender
        
        currentUserSignedIn = true
    }
}

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        
        ZStack {
            switch viewModel.onBoardingState {
            case 0:
                welcomeSection
            case 1:
                addNameSection
            case 2:
                addAgeSection
            case 3:
                addGenderSection
            default:
                Text("Some View")
            }
            
            VStack {
                bottomButton
            }

        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle))
        }
    }
}

#Preview {
    OnboardingView()
        .background(Color.purple)
}

extension OnboardingView {
    private var welcomeSection: some View {
        VStack(spacing: 30) {
            Spacer()
            Image(systemName: "info.bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundStyle(.white)
            Text("Random Information")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .overlay(alignment: .bottom) {
                    Capsule(style: .continuous)
                        .frame(height: 3)
                        .offset(y:5)
                        .foregroundStyle(.white)
                }
            Text("This application is a collection of random features that I've worked with combined into one. Simply after log in you will have access and I may add more features as time goes on!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding()
    }
    
    private var addNameSection: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Enter your name below")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            TextField("Enter your name here...", text: $viewModel.name)
                .font(.headline)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(.capsule)
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    private var addAgeSection: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Select your age below")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text(String(format: "%.0f", viewModel.age))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Slider(value: $viewModel.age, in: 18...100, step: 1)
                .tint(.white)
            Spacer()
            Spacer()
        }
        .padding()
    }
    
    private var addGenderSection: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Select Gender below")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text(viewModel.gender.count > 1 ? viewModel.gender : "Your Selection")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Picker("Gender Picker", selection: $viewModel.gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
                Text("Non-Binary").tag("Non-Binary")
            }
            .pickerStyle(.palette)
            .frame(height: 30)
            .frame(maxWidth: .infinity)
            .background(.gray)
            .clipShape(.capsule)
            .padding()
            
            Spacer()
            Spacer()
        }
    }
    
    private var bottomButton: some View {
        VStack {
            Spacer()
            
            Text(
                viewModel.onBoardingState == 0 ? "SIGN UP" :
                    viewModel.onBoardingState == 3 ? "FINISH" : "NEXT"
            )
                .font(.headline)
                .foregroundStyle(.purple)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(.capsule)
                .padding()
                .onTapGesture {
                    viewModel.handleButtonButton()
                }
        }
    }
}
