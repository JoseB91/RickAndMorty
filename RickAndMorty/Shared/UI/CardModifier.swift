//
//  CardModifier.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}
