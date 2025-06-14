//
//  ViewModifierExtension.swift
//  PracticeProjectThree
//
//  Created by Rahul Avale on 6/14/25.
//

import Foundation
import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.semibold)
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.purple)
            .background()
            .clipShape(.capsule)
            .padding()
    }
}

extension View {
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonModifier())
    }
}
