//
//  TestHelpers.swift
//  RickAndMortyTests
//
//  Created by José Briones on 26/6/25.
//

import Foundation
@testable import RickAndMorty

func anyURL() -> URL {
   URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension String {
    func makeJSON() -> Data {
        return self.data(using: .utf8)!
    }
}
