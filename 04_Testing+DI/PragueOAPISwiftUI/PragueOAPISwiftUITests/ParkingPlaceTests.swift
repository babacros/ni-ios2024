//
//  ParkingPlaceTests.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import XCTest
@testable import PragueOAPISwiftUI

final class ParkingPlaceTests: XCTestCase {
    func testFreeSpacesString() throws {
        // Given
        let parkingPlace = ParkingPlace.mock()
        
        // When
        let freeSpacesString = parkingPlace.freeSpacesString
        
        // Then
        XCTAssertEqual(freeSpacesString, "5/10")
    }
    
    func testHasAvailablePlaceTrue() throws {
        // Given
        let parkingPlace = ParkingPlace.mock()
        
        // When
        let hasAvailablePlace = parkingPlace.hasAvailablePlace
        
        // Then
        XCTAssertTrue(hasAvailablePlace)
    }
    
    func testHasAvailablePlaceFalse() throws {
        // Given
        let parkingPlace = ParkingPlace.mock(numberOfFreePlaces: 0)
        
        // When
        let hasAvailablePlace = parkingPlace.hasAvailablePlace
        
        // Then
        XCTAssertFalse(hasAvailablePlace)
    }
}
