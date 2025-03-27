//
//  DataStructureView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/11/25.
//

import SwiftUI

struct DataStructureListContent: Identifiable {
    let id: String
    let title: String
    let view: AnyView
}

class DataStructureViewModel: ObservableObject {
    
    let dataStructureContents : [DataStructureListContent] = [
        DataStructureListContent(id: "1", title: "Five Times Show", view: AnyView(FiveTimesShowView())),
        DataStructureListContent(id: "2", title: "Subscript No Repeat", view: AnyView(SubscriptRepeatView())),
        DataStructureListContent(id: "3", title: "Sorting", view: AnyView(SortingView())),
        DataStructureListContent(id: "4", title: "Get Max Area", view: AnyView(GetMaxAreaView())),
        DataStructureListContent(id: "5", title: "Two Sum", view: AnyView(TwoSumView()))
    ]
    
}

struct DataStructureView: View {
    
    @StateObject private var viewModel = DataStructureViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                               center: .topLeading,
                               startRadius: 5,
                               endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
                
                List(viewModel.dataStructureContents) { data in
                    NavigationLink {
                        data.view
                    } label: {
                        Label(data.title, systemImage: "fossil.shell")
                    }

                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Data Structures")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.black)
        
    }
}

#Preview {
    DataStructureView()
}
