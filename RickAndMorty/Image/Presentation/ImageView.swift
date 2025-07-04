//
//  ImageView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI
 
struct ImageView: View {
 
    var imageViewModel: ImageViewModel<UIImage>

    init(imageViewModel: ImageViewModel<UIImage>) {
        self.imageViewModel = imageViewModel
    }

    var body: some View {
        ZStack {
            if imageViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else {
                Image(uiImage: imageViewModel.image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task {
            await imageViewModel.loadImage()
        }
    }
}
