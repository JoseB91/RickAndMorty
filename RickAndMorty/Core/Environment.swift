//
//  Environment.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import SwiftUI

struct ImageViewLoaderKey: EnvironmentKey {
    static let defaultValue: ((URL) -> ImageView)? = nil
}

extension EnvironmentValues {
    var imageViewLoader: ((URL) -> ImageView)? {
        get { self[ImageViewLoaderKey.self] }
        set { self[ImageViewLoaderKey.self] = newValue }
    }
}
