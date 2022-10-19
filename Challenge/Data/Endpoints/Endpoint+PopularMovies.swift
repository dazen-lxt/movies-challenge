//
//  PopularEndpoint.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import Alamofire

extension Endpoint {

    struct PopularMovies: EndpointProtocol {
        var path: String {
            return "movie/popular"
        }

        var method: HTTPMethod {
            return .get
        }
    }
}
