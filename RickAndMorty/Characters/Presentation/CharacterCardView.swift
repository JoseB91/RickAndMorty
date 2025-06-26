//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI

struct CharacterCardView: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            // Flag section
            ImageView(url: character.image)
                .frame(width: 80, height: 80)
            
            // Info section
            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.headline)
                Text(character.origin)
                    .font(.callout)
                Text(character.location)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

#Preview {
    let character = MockCharactersViewModel.mockCharacter()
    CharacterCardView(character: character)
}

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
