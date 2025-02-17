//
//  FunctionalitiesView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 1/17/25.
//

import SwiftUI

struct ListContent: Identifiable {
    let id: Int
    let title: String
    let view: AnyView
    let image: String
}

class FuntionalitiesViewModel: ObservableObject {
    @Published var listContent: [ListContent] = [
        ListContent(id: 1, title: "Stories", view: AnyView(StoriesSheetWebView()), image: "book.pages"),
        ListContent(id: 2, title: "Weather", view: AnyView(WeatherView()), image: "sun.max"),
        ListContent(id: 3, title: "Beers", view: AnyView(BeersView()), image: "wineglass.fill"),
        ListContent(id: 4, title: "Quiz", view: AnyView(QuizFormView()), image: "questionmark.app")
    ]
}

struct FunctionalitiesView: View {
    
    @StateObject private var viewModel = FuntionalitiesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                List(viewModel.listContent) { data in
                    NavigationLink {
                        data.view
                    } label: {
                        Label(data.title, systemImage: data.image)
                    }
                    
                }
                .scrollContentBackground(.hidden)

                
            }
            .navigationTitle("Funtionalities")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.black)
    }
}

#Preview {
    FunctionalitiesView()
}
