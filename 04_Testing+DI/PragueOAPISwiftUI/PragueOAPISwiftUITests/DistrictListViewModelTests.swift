//
//  DistrictListViewModelTests.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import XCTest
@testable import PragueOAPISwiftUI
import CoreLocation

final class DistrictListViewModelTests: XCTestCase {
    var viewModel: DistrictListViewModel!
    var locationManager: LocationManagerMock!
    var districtAPIService: DistrictAPIServiceMock!
    
    override func setUp() {
        super.setUp()
        
        locationManager = LocationManagerMock()
        districtAPIService = DistrictAPIServiceMock()
        viewModel = DistrictListViewModel(
            locationManager: locationManager,
            districtAPIService: districtAPIService
        )
    }
    
    func testFetchFirstPage() async throws {
        // Given
        let district = District.mock(
            name: "Praha 6",
            id: 17,
            slug: "praha-6"
        )
        
        districtAPIService.districtsReturnValue = [
            district
        ]
        
        // When
        try await viewModel.fetchFirstPage()
        
        // Then
        XCTAssertEqual(viewModel.districts.count, 1)
        XCTAssertEqual(
            viewModel.districts.first,
            district
        )
    }
}

final class LocationManagerMock: LocationManager {
    override var currentLocation: CLLocationCoordinate2D {
        .init(latitude: 50.10496, longitude: 14.38957)
    }
}

final class DistrictAPIServiceMock: DistrictAPIService {
    var districtsReturnValue: [District] = []
    override func districts(
        currentLocation: CLLocationCoordinate2D,
        offset: Int
    ) async throws -> [District] {
        districtsReturnValue
    }
}
