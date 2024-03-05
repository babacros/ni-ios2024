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
    var id: String { name }
    var location: CLLocationCoordinate2D {
        .init(
            latitude: lat,
            longitude: lon
        )
    }
}
