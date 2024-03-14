//
//  APIParkingPlace.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation

struct APIParkingPlace: Decodable {
    let properties: Properties
    let geometry: Geometry
}

extension APIParkingPlace {
    struct Properties: Decodable {
        let id: Int
        let name: String
        let numberOfFreePlaces: Int
        let totalNumberOfPlaces: Int
        let parkingType: ParkingType
        let address: Address
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case numberOfFreePlaces = "num_of_free_places"
            case totalNumberOfPlaces = "total_num_of_places"
            case parkingType = "parking_type"
            case address
        }
    }
    
    struct ParkingType: Codable {
        let description: String
    }
}
