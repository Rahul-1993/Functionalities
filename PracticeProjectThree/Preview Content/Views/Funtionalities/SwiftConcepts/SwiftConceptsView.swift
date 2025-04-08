//
//  SwiftConceptsView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 4/8/25.
//

import SwiftUI

struct ListSwiftConcepts: Identifiable {
    let id: Int
    let conceptName: String
    let conceptView: AnyView
    let conceptImage: String
}

class SwiftConceptsViewModel: ObservableObject {
    let swiftConceptsList: [ListSwiftConcepts] = [
        ListSwiftConcepts(id: 1, conceptName: "Protocol & DI", conceptView: AnyView(FirstProtocolView()), conceptImage: "swift")
    ]
}

struct SwiftConceptsView: View {
    
    @StateObject private var viewModel = SwiftConceptsViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.swiftConceptsList) { data in
                NavigationLink {
                    data.conceptView
                } label: {
                    Label(data.conceptName, systemImage: "swift")
                }

            }
            .navigationTitle("Swift Concepts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SwiftConceptsView()
}
