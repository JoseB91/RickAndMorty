//
//  ImageMapper.swift
//  RickAndMorty
//
//  Created by José Briones on 4/7/25.
//

import Foundation

public final class ImageMapper {
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw MapperError.unsuccessfullyResponse
        }

        return data
    }
}
