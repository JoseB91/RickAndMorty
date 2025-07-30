//
//  MockImage.swift
//  RickAndMorty
//
//  Created by José Briones on 30/7/25.
//

import Foundation

struct MockImageRepository: ImageRepository {
    func loadImage() async throws -> Data {
        Data()
    }
}

struct MockImageComposer {
    func composeImageView(with url: URL) -> ImageView {
        let mockRepository = MockImageRepository()
        let mockViewModel = ImageViewModel(repository: mockRepository)
        return ImageView(imageViewModel: mockViewModel)
    }
}
