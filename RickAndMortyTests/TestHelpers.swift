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

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
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

func mockCharacters() -> (models: [Character], local: [LocalCharacter]) {
    let models = [MockCharactersViewModel.mockCharacter()]
    let local = models.toLocal()
    return (models, local)
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
        
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
