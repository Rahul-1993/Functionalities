//
//  StoriesSheetWebView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 2/17/25.
//

import SwiftUI

struct Story: Codable, Identifiable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
}

class StoriesSheetWebDataService {
    func fetchData() async -> [Story]? {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: storiesUrlString)!)
            return handleResponse(data: data, response: response)
        } catch {
            print("Error fetching data from URL")
            return nil
        }
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> [Story]? {
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode <= 300 else {
            return nil
        }
        return try? JSONDecoder().decode([Story].self, from: data)
    }
}

class StoriesSheetWebViewModel: ObservableObject {
    
    @Published var storiesArray: [Story] = []
    let dataService = StoriesSheetWebDataService()
    
    init() {
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        if let returnedData = await dataService.fetchData() {
            await MainActor.run {
                self.storiesArray = returnedData
            }
        }
    }
    
}

struct StoriesSheetWebView: View {
    
    @StateObject private var viewModel = StoriesSheetWebViewModel()
    @State private var selectedUrl: URL?
    @State private var isPresented: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {

                
                List(viewModel.storiesArray) { data in
                    ZStack {
                        RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                                       center: .topLeading,
                                       startRadius: 5,
                                       endRadius: UIScreen.main.bounds.height)
                        VStack(alignment: .center) {
                            Text(data.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(data.strap)
                                .multilineTextAlignment(.center)
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .onTapGesture {
                            selectedUrl = data.url
                            isPresented.toggle()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .listRowSeparator(.hidden)

                }
                .sheet(isPresented: $isPresented) {
                    if let url = selectedUrl {
                        WebView(url: url)
                            .presentationDetents([.medium, .large])
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        
    }
}

#Preview {
    StoriesSheetWebView()
}
