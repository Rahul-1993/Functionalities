//
//  CarsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/17/25.
//

import SwiftUI

class CarViewModel: ObservableObject {
    
    @Published var token: String = ""
    
    let carApiAuth = CarApiClient()
    
    init() {
        Task {
            try await auth()
        }
    }
    
    func auth() async throws {
        
        do {
            let token = try await carApiAuth.fetchJWT()
            await MainActor.run {
                self.token = token
            }
        } catch {
            throw URLError(.badServerResponse)
        }
        
        
    }
    
}

struct CarsView: View {
    @StateObject var viewModel = CarViewModel()
    
    
    var body: some View {
        Text(viewModel.token.count > 0 ?
             viewModel.token : "No Token")
    }
}

#Preview {
    CarsView()
}
