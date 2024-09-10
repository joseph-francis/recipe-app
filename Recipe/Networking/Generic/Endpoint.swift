//
//  Endpoint.swift
//  Recipe
//
//  Created by Joseph Francis on 9/8/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var domain: String { get }
}

extension Endpoint {

    func buildRequest() -> URLRequest? {
        guard let url = URL(string: domain + path) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
