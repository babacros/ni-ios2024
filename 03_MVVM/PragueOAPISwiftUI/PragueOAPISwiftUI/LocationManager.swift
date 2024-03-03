//
//  LocationManager.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation
import CoreLocation

final class LocationManager {
    static let shared = LocationManager()
    private init() {}
    
    var currentLocation: CLLocationCoordinate2D {
        .init(latitude: 50.10496, longitude: 14.38957)
    }
    
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> Int {
        Int(currentLocation.clLocation.distance(from: location.clLocation))
    }
}

extension CLLocationCoordinate2D {
    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}
