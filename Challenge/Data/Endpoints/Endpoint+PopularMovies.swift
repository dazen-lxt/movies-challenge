//
//  PopularEndpoint.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import Alamofire

extension Endpoint {

    struct PopularMovies {
        var page: Int
    }
}

extension Endpoint.PopularMovies: EndpointProtocol {
    var path: String {
        return "movie/popular"
    }

    var method: HTTPMethod {
        return .get
    }

    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "page", value: "\(page)")]
    }
}
