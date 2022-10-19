//
//  Endpoint+SearchMovies.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 19/10/22.
//

import Alamofire

extension Endpoint {

    struct SearchMovies {
        var page: Int
        var query: String
    }
}

extension Endpoint.SearchMovies: EndpointProtocol {
    var path: String {
        return "search/movie"
    }

    var method: HTTPMethod {
        return .get
    }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }
}
