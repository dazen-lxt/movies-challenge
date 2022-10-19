//
//  ApiClient.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 14/10/22.
//

import Alamofire
import Foundation

final class ApiClient: Session {

    private static var privateShared: ApiClient?
    public static var sharedInstance: ApiClient {
        guard let uwShared = privateShared else {
            let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
            configuration.urlCache = URLCache.shared
            configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 60
            privateShared = ApiClient(configuration: configuration)
            return privateShared!
        }
        return uwShared
    }

    public func doRequest<T: Decodable>(
        req: EndpointProtocol,
        dateFormat: String = "yyyy-MM-dd",
        completionHandler: @escaping ((ApiResult<T>) -> Void)
    ) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        _ = self
            .request(req)
            .responseDecodable(of: T.self, decoder: decoder) { response in
                var output: ApiResult<T>
                let statusCode: Int? = response.response?.statusCode
                switch response.result {
                case .success(let value):
                    output = ApiResult.success(value, statusCode ?? 0)
                case .failure(let error):
                    output = ApiResult.failure(error, response.data, statusCode ?? 0)
                }
                completionHandler(output)
            }
    }
}

public enum ApiResult<T> {
    case success(T, Int)
    case failure(Error, Data?, Int)
}

enum Endpoint {}
