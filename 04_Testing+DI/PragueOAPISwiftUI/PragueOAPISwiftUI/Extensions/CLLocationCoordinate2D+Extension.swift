//
//  CLLocationCoordinate2D+Extension.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var clLocation: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}
