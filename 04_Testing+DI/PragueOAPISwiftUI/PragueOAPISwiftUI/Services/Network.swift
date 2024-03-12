//
//  Network.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation

protocol Networking {
    func performRequest(
        url: URL,
        httpMethod: Network.HTTPMethod,
        headers: [String: String]
    ) async throws -> Data
}

final class Network: Networking {
    static let acceptJSONHeader = ["accept": "application/json; charset=utf-8"]
    var apiKeyHeader: [String: String] {
        ["X-Access-Token": UserDefaults.standard.string(forKey: "apiKey") ?? ""]
    }
    
    // MARK: - Public Interface
    
    func performRequest(
        url: URL,
        httpMethod: HTTPMethod,
        headers: [String: String]
    ) async throws -> Data {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers.merging(
            apiKeyHeader,
            uniquingKeysWith: { current, _ in current }
        )
        
        print(
            "⬆️ "
            + url.absoluteString
        )
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let httpResponse = response as? HTTPURLResponse
        
        print(
            "⬇️ "
            + "[\(httpResponse?.statusCode ?? -1)]: " + url.absoluteString //+ "\n"
//                + String(data: data, encoding: .utf8)!
        )
        
        return data
    }
}

extension Network {
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum Endpoint {
        case parkings
        case citydistricts
        case playgrounds
        
        var base: String {
            switch self {
            case .parkings:
                "https://api.golemio.cz/v1"
            case .citydistricts, .playgrounds:
                "https://api.golemio.cz/v2"
            }
        }
        
        var path: String {
            switch self {
            case .parkings:
                "/parkings"
            case .citydistricts:
                "/citydistricts"
            case .playgrounds:
                "/playgrounds"
            }
        }
        
        var url: URLComponents {
            URLComponents(string: base + path)!
        }
    }
}
