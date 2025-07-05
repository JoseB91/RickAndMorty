//
//  ImageView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI
 
struct ImageView: View {
 
    var imageViewModel: ImageViewModel

    init(imageViewModel: ImageViewModel) {
        self.imageViewModel = imageViewModel
    }

    var body: some View {
        ZStack {
            if imageViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                Image.load(from: imageViewModel.data)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            await imageViewModel.loadImage()
        }
    }
}

#Preview {
    let imageViewModel = ImageViewModel(repository: MockImageRepository())
    ImageView(imageViewModel: imageViewModel)
}
