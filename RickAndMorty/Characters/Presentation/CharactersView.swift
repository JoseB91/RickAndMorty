//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI

struct CharactersView: View {
    @State var charactersViewModel: CharactersViewModel
    let imageViewLoader: (URL) -> ImageView
    //@Environment(\.imageViewLoader) private var imageViewLoader

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
                            CharacterCardView(character: character, imageViewLoader: imageViewLoader)
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
        .alert(item: $charactersViewModel.errorMessage) { errorModel in
            Alert(
                title: Text("Error"),
                message: Text(errorModel.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

//#Preview {
//    
//    NavigationStack {
//        let mockImageComposer = MockImageComposer()
//        let charactersViewModel = CharactersViewModel(repository: MockCharactersRepository())
//        
//        CharactersView(charactersViewModel: charactersViewModel)
//            .environment(\.imageViewLoader, mockImageComposer.composeImageView)
//    }
//}
