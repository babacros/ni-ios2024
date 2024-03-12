//
//  LocationManagerMock.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
@testable import PragueOAPISwiftUI
import CoreLocation

final class LocationManagerMock: LocationManaging {
    var currentLocationReturnValue: CLLocationCoordinate2D?
    var currentLocation: CLLocationCoordinate2D {
        currentLocationReturnValue ?? .init(latitude: 0, longitude: 0)
    }
    
    var onDistanceFromCurrentLocation: ((CLLocationCoordinate2D) -> Void)?
    var distanceFromCurrentLocationReturnValue: Int?
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> Int {
        onDistanceFromCurrentLocation?(location)
        return distanceFromCurrentLocationReturnValue ?? 0
    }
}
