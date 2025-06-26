//
//  MapperHelpers.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

public enum MapperError: Error {
    case unsuccessfullyResponse
}

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
