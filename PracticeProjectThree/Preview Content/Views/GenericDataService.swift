//
//  GenericDataService.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/21/25.
//

import Foundation

class GenericDataService {
    
    func fetchData<T: Decodable>(from url: URL) async -> T? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            print("Error")
            return nil
        }
    }
    
    func handleResponse<T: Decodable>(data: Data?, response: URLResponse?) -> T? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch  {
            print("Decoding Error")
            return nil
        }
    }
    
}
