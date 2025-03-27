//
//  CarApiClient.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/17/25.
//

import Foundation

struct JWTRequest: Codable {
    let api_token: String
    let api_secret: String
}

struct JWTResponse: Codable {
    let token: String
}

class CarApiClient {
    private let apiToken = carApiKey
    private let apiSecret = carApiSecret
    private let authUrl = URL(string: (carBaseUrl + carAuth))!
    private var jwt: String?
    private var jwtExpiration: String?
    
    func fetchJWT() async throws -> String {
        var request = URLRequest(url: authUrl)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = JWTRequest(api_token: carApiKey, api_secret: carApiSecret)
        let jsonData = try JSONEncoder().encode(requestBody)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request JSON: ", jsonString)
        }
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code:", httpResponse.statusCode)
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body:", responseBody)
            }
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let receivedToken = String(data: data, encoding: .utf8) else {
            throw URLError(.unknown)
        }
        
        cacheJWT(token: receivedToken)
        return String(data: data, encoding: .utf8) ?? ""
        
    }
    
    func cacheJWT(token: String) {
        UserDefaults.standard.set(token, forKey: "jwtToken")
    }
    
    func loadCachedJWT() async throws -> String? {
        if let token = UserDefaults.standard.string(forKey: "jwtToken") {
            return token
        }
        return nil
    }
}
