//
//  TaskGroupView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 6/13/25.
//

import SwiftUI

struct NewsStoriesModel: Identifiable, Codable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
    
}

@Observable
class TaskGroupViewModel {
    
    var stories = [NewsStoriesModel]()
    
    func loadStories() async {
        do {
            stories = try await withThrowingTaskGroup(of: [NewsStoriesModel].self, body: { group in
                for i in 1...5 {
                    group.addTask {
                        let url = URL(string: "https://hws.dev/news-\(i).json")!
                        let (data,_) = try await URLSession.shared.data(from: url)
                        return try JSONDecoder().decode([NewsStoriesModel].self, from: data)
                    }
                }
                
                var allStories = [NewsStoriesModel]()
                
                for try await stories in group {
                    allStories.append(contentsOf: stories)
                }
                
                return allStories.sorted{ $0.title < $1.title}
            })
        } catch  {
            print("Error")
        }
    }
    
    
}

struct TaskGroupView: View {
    
    @State private var viewModel = TaskGroupViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.stories) { data in
                    NavigationLink {
                        WebView(url: data.url)
                    } label: {
                        Label(data.title, systemImage: "swift")
                    }
                }
            }
            .navigationTitle("Stories")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await viewModel.loadStories()
        }
    }
}

#Preview {
    TaskGroupView()
}
