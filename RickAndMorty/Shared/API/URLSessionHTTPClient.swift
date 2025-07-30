//
//  URLSessionHTTPClient.swift
//  RickAndMorty
//
//  Created by José Briones on 26/6/25.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            return (data, httpResponse)
        } catch let urlError as URLError {
            throw urlError
        } catch {
            throw URLError(.unknown, userInfo: [NSUnderlyingErrorKey: error])
        }
    }
}
