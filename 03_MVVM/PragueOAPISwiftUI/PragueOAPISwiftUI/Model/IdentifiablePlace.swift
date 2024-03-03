//
//  IdentifiablePlace.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation
import MapKit

struct IdentifiablePlace: Identifiable {
    let name: String
    let location: CLLocationCoordinate2D
    var id: String {
        name
    }
    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.location = .init(
            latitude: lat,
            longitude: long
        )
    }
}
