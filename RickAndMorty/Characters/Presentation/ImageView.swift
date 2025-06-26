//
//  ImageView.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import SwiftUI

struct ImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            case .failure:
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                
            @unknown default:
                EmptyView()
            }
        }
    }
}


