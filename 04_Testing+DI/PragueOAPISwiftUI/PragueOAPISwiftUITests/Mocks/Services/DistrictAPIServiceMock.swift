//
//  DistrictAPIServiceMock.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
@testable import PragueOAPISwiftUI
import CoreLocation

final class DistrictAPIServiceMock: DistrictAPIServicing {
    var onDistricts: ((CLLocationCoordinate2D, Int) -> Void)?
    var districtsReturnValue: [District] = []
    var districtsShouldFail: Bool = false
    func districts(
        currentLocation: CLLocationCoordinate2D,
        offset: Int
    ) async throws -> [District] {
        onDistricts?(currentLocation, offset)
        guard !districtsShouldFail else {
            throw NSError(domain: "districtsShouldFail", code: 666)
        }
        return districtsReturnValue
    }
    
    func playgrounds(districtID: String) async throws -> [Playground] {
        []
    }
}
