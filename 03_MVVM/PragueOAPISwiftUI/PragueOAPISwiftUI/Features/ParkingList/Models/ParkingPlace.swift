//
//  ParkingPlace.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation

struct ParkingPlace: Identifiable, Hashable {
    let id: Int
    let name: String
    let numberOfFreePlaces: Int
    let totalNumberOfPlaces: Int
    let parkingType: String
    let address: Address
    let location: IdentifiablePlace?
    
    var freeSpacesString: String {
        String(numberOfFreePlaces) + "/" + String(totalNumberOfPlaces)
    }
}
