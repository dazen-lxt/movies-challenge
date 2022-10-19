//
//  EndpointProtocol.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import Alamofire

public protocol EndpointProtocol: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var params: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var queryItems: [URLQueryItem] {get}
}

extension EndpointProtocol {

    public var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/")!
    }

    func encode(_ urlRequest: URLRequestConvertible) throws -> URLRequest {
        return try encoding.encode(urlRequest, with: params)
    }

    public func asURLRequest() throws -> URLRequest {
        var urlComponent: URLComponents = URLComponents(string: baseURL.appendingPathComponent(path).absoluteString)!
        urlComponent.queryItems = queryItems
        urlComponent.queryItems?.append(
            URLQueryItem(
                name: "api_key",
                value: "3c216997fb33881d5fac6e79d50a87b0"
            )
        )
        var urlRequest: URLRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = method.rawValue
        if let headers: HTTPHeaders = headers {
            urlRequest.headers = headers
        }
        headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.name) }
        urlRequest = try encode(urlRequest)
        return urlRequest
    }

    public var queryItems: [URLQueryItem] {
        return []
    }

    public var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    public var encoding: ParameterEncoding {
        return Alamofire.JSONEncoding.default
    }

    public var params: Parameters? {
        return nil
    }
}
