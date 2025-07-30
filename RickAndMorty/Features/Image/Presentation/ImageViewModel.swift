//
//  ImageViewModel.swift
//  RickAndMorty
//
//  Created by José Briones on 3/7/25.
//

import Foundation

@Observable
final class ImageViewModel {
    private let repository: ImageRepository
    
    var isLoading = false
    var data: Data?
    
    init(repository: ImageRepository) {
        self.repository = repository
    }
    
    @MainActor
    func loadImage() async {
        isLoading = true
        defer { isLoading = false }
        
        data = try? await repository.loadImage()
    }
}
