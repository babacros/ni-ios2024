//
//  Geometry.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation

struct Geometry: Codable, Hashable {
    let coordinates: [Double]
    
    var coordinatesTupple: (lat: Double, lon: Double) {
        guard coordinates.count == 2 else { return (0, 0) }
        return (
            lat: coordinates[1],
            lon: coordinates[0]
        )
    }
}
