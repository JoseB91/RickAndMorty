//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI

struct CharactersView: View {
    @State var charactersViewModel: CharactersViewModel
    //@Binding var navigationPath: NavigationPath

    var body: some View {
        ZStack {
            if charactersViewModel.isLoading {
                ProgressView("Loading characters...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    ForEach(charactersViewModel.characters) { character in
                        Button {
                            //navigationPath.append(Character.officialName)
                        } label: {
                            CharacterCardView(character: character)
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

#Preview {
    let charactersViewModel = CharactersViewModel(
        charactersLoader: MockCharactersViewModel.mockcharactersLoader
    )
    
    NavigationStack {
        CharactersView(charactersViewModel: charactersViewModel)
                      //navigationPath: .constant(NavigationPath())
    }
}
