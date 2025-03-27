//
//  SecondAppStorageView.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 3/24/25.
//

import SwiftUI

struct SecondAppStorageView: View {
    @AppStorage("username") var currentUserName1: String?
    var body: some View {
        Text(currentUserName1 ?? "")
    }
}

#Preview {
    SecondAppStorageView()
}
