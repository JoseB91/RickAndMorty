//
//  ImageViewModel.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import SwiftUI

@Observable
final class ImageViewModel {
    private let repository: ImageRepository
    
    var isLoading = false
    var data = Data()
    
    init(repository: ImageRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadImage() async {
        isLoading = true
        
        do {
            data = try await repository.loadImage()
        } catch {
            print(error) //TODO: Decide here what to do
        }
        
        isLoading = false
    }
    
}

final class MockImageRepository: ImageRepository {
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

extension Image {
    static func load(from data: Data, fallback: String = "photo") -> Image {
        guard let uiImage = UIImage(data: data) else {
            return Image(systemName: fallback)
        }
        return Image(uiImage: uiImage)
    }
}
