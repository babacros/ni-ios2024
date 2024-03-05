//
//  IdentifiablePlace.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation
import MapKit

struct IdentifiablePlace: Identifiable, Hashable {
    let name: String
    let lat: Double
    let lon: Double
    var location: CLLocationCoordinate2D {
        .init(
            latitude: lat,
            longitude: lon
        )
    }
    var id: String {
        name
    }
    
    init(name: String, lat: Double, lon: Double) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}
