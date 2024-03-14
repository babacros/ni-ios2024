//
//  URLQueryItem+Extension.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
import CoreLocation

extension URLQueryItem {
    static func range(_ value: Int = 50000) -> URLQueryItem {
        .init(name: "range", value: String(value))
    }
    
    static func limit(_ value: Int = 10) -> URLQueryItem {
        .init(name: "limit", value: String(value))
    }
    
    static func offset(_ value: Int = 0) -> URLQueryItem {
        .init(name: "offset", value: String(value))
    }
    
    static func latlng(_ value: CLLocationCoordinate2D) -> URLQueryItem {
        .init(
            name: "latlng",
            value: "\(value.latitude),\(value.longitude)"
        )
    }
}
