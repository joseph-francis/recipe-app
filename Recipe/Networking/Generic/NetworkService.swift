//
//  NetworkService.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request, delegate: nil)
    }
}

protocol NetworkServiceProtocol: AnyObject {
    func fetch<T: Decodable>(
        from endpoint: Endpoint,
        as type: T.Type
    ) async throws -> T
}

class NetworkService: NetworkServiceProtocol {

    private let session: URLSessionProtocol

    enum ErrorTypes: Error {
        case cannotBuildRequest
        case badServerResponse
    }

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch<T: Decodable>(
        from endpoint: Endpoint,
        as type: T.Type
    ) async throws -> T {
        guard let request = endpoint.buildRequest() else {
            throw ErrorTypes.cannotBuildRequest
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
            throw ErrorTypes.badServerResponse
        }

        let decodable = try JSONDecoder().decode(T.self, from: data)
        return decodable
    }
}
