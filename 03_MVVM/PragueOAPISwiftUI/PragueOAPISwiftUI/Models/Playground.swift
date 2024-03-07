//
//  Playground.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation

struct Playground: Decodable, Hashable {
    let properties: PlaygroundProperties
    let geometry: Geometry
    
    var place: IdentifiablePlace? {
        let coordinates = geometry.coordinates
        guard coordinates.count == 2 else { return nil }
        return IdentifiablePlace(
            name: properties.name,
            lat: coordinates[1],
            lon: coordinates[0]
        )
    }
}

struct PlaygroundProperties: Decodable, Hashable {
    let name: String
    let image: PlaceImage
    let perex: String
    let content: String
    let address: Address
    let id: Int
}

struct PlaceImage: Decodable, Hashable {
    let url: URL
}
