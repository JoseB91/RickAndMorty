//
//  ImageHelper.swift
//  RickAndMorty
//
//  Created by José Briones on 30/7/25.
//

import SwiftUI

extension Image {
    static func load(from data: Data?, fallback: String = "photo") -> Image {
        guard let data, let uiImage = UIImage(data: data) else {
            return Image(systemName: fallback)
        }
        return Image(uiImage: uiImage)
    }
}
