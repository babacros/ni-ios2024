//
//  ParkingPlace.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
@testable import PragueOAPISwiftUI

extension ParkingPlace {
    static func mock(
        id: Int = 0,
        name: String = "MyName",
        numberOfFreePlaces: Int = 5,
        totalNumberOfPlaces: Int = 10,
        parkingType: String = "P+R",
        address: Address = .init(addressFormatted: "Address"),
        location: IdentifiablePlace? = nil
    ) -> ParkingPlace {
        ParkingPlace(
            id: id,
            name: name,
            numberOfFreePlaces: numberOfFreePlaces,
            totalNumberOfPlaces: totalNumberOfPlaces,
            parkingType: parkingType,
            address: address,
            location: location
        )
    }
}
