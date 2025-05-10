//
//  EnumPracticeView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/9/25.
//

import SwiftUI

enum BiometricType {
    case fingerprint
    case faceid
    case newOne
}

enum AuthMethod {
    case password(String, String)
    case biometric(BiometricType)
    case oauth(provider: String, token: String)
    case token(String)
}

enum ErrorAuth: Error {
    case urlError(String)
    case decodingError
    case randomError
}

class LoginAuthentication {
    
    func loginUsingPassword(name: String?, pass: String?) -> String {
//        let returnString = "UsingPassword \(name) \(pass)"
//        return returnString
        
        guard let userCount = name,
              let password = pass else {
            errorResponse(error: .randomError)
            return ""
        }
        
        if userCount.count < 5 {
            errorResponse(error: .decodingError)
            return ""
        } else {
            let returnValue = "UsingPassword \(String(describing: userCount)) \(String(describing: password))"
            return returnValue
        }
    }
    
    func errorResponse(error: ErrorAuth) {
        switch error {
        case .decodingError:
            print("Decoding error")
        case .urlError(let string):
            print("url error \(string)")
        case .randomError:
            print("Random Error")
        }
    }
    
}

class EnumPracticeViewModel: ObservableObject {
    
    @Published var value: String = "No login yet"
    
    let login = LoginAuthentication()
    
    func loginFunction(using method: AuthMethod) {
        switch method {
        case .password(let string, let string2):
            self.value = login.loginUsingPassword(name: string, pass: string2)
        case .biometric(let biometricType):
            switch biometricType {
            case .fingerprint:
                self.value = "Fingerprint login"
            case .faceid:
                self.value = "FaceID login"
            case .newOne:
                self.value = "New bio login"
            }
        case .oauth(let provider, let token):
            self.value = "Oauth login \(provider) \(token)"
        case .token(let string):
            self.value = "Token login \(string)"
        }
    }
    
}

struct EnumPracticeView: View {
    
    @StateObject private var viewModel = EnumPracticeViewModel()
    
    var body: some View {
        VStack {
            Button {
                viewModel.loginFunction(using: .password("Hell023", ""))
            } label: {
                Label("Login Using biometric", systemImage: "cloud")
            }
            
            Text(viewModel.value)

        }
    }
}

#Preview {
    EnumPracticeView()
}
