//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI

struct CharacterCardView: View {
    let character: Character
    let imageViewLoader: (URL) -> ImageView
    //@Environment(\.imageViewLoader) private var imageViewLoader
    
    var body: some View {
        HStack(spacing: 16) {
            
            imageViewLoader(character.image)
                .frame(width: 80, height: 80)
            
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

//#Preview {
//    let character = MockCharactersViewModel.mockCharacter()
//    let mockImageComposer = MockImageComposer()
//
//    CharacterCardView(character: character)
//        .environment(\.imageViewLoader, mockImageComposer.composeImageView)
//}
