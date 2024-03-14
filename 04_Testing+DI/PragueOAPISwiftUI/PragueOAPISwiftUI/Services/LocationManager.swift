//
//  LocationManager.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation
import CoreLocation

protocol HasLocationManager {
    var locationManager: LocationManaging { get }
}

protocol LocationManaging {
    var currentLocation: CLLocationCoordinate2D { get }
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> Int
}

class LocationManager: LocationManaging {
    
    // MARK: - Public Properties
    
    var currentLocation: CLLocationCoordinate2D {
        .init(latitude: 50.10496, longitude: 14.38957)
    }
    
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> Int {
        Int(currentLocation.clLocation.distance(from: location.clLocation))
    }
}
