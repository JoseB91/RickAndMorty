//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI

struct CharactersView: View {
    @State var charactersViewModel: CharactersViewModel
    let imageView: (URL) -> ImageView
    
    var body: some View {
        ZStack {
            if charactersViewModel.isLoading {
                ProgressView("Loading characters...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    ForEach(charactersViewModel.characters) { character in
                        Button {
                        } label: {
                            CharacterCardView(character: character,
                                              imageView: imageView)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await charactersViewModel.loadCharacters()
        }
        .navigationTitle("Rick and Morty")
        .alert(item: $charactersViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

//#Preview {
//    let charactersViewModel = CharactersViewModel(
//        charactersLoader: MockCharactersViewModel.mockcharactersLoader
//    )
//    
//    NavigationStack {
//        CharactersView(charactersViewModel: charactersViewModel,
//        imageView: )
//    }
//}
