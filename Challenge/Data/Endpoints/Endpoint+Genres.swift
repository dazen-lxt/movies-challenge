//
//  Endpoint+Genres.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import Alamofire

extension Endpoint {

    struct Genres: EndpointProtocol {
        var path: String {
            return "genre/movie/list"
        }

        var method: HTTPMethod {
            return .get
        }
    }
}
