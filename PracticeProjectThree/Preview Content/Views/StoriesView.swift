//
//  StoriesView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/17/25.
//

import SwiftUI

struct Stories: Identifiable, Codable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
}

class StoriesDataService {
    private let genericDataService = GenericDataService()
    let url = URL(string: "https://hws.dev/news-3.json")
    
    func fetchStories(from url: URL) async -> [Stories]? {
        await genericDataService.fetchData(from: url)
    }
    
    func downloadStories() async -> [Stories]? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url!)
            return handleResponse(data: data, response: response)
        } catch {
            print("Error")
            return nil
        }
        
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> [Stories]? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        
        return try? JSONDecoder().decode([Stories].self, from: data)
    }
}

class StoriesViewModel: ObservableObject {
    @Published var dataArray: [Stories] = []
    
    let dataService = StoriesDataService()
    private let storiesUrl = URL(string: storiesUrlString)
    
    func loadDataGeneric() async {
        if let data = await dataService.fetchStories(from: storiesUrl!) {
            await MainActor.run {
                self.dataArray = data
            }
        }
    }

    
    func loadData() async {
        let returnedData = await dataService.downloadStories()
        
        if let data = returnedData {
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
    
    
}

struct StoriesView: View {
    
    @StateObject private var viewModel = StoriesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                List(viewModel.dataArray) { data in
                    NavigationLink {
                        WebView(url: data.url)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(data.title)
                                .font(.headline)
                            
                            Text(data.strap)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .task {
                await viewModel.loadDataGeneric()
            }
        }

    }
}

#Preview {
    StoriesView()
}
