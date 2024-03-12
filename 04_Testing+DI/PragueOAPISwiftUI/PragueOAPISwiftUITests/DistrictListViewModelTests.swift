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
    
    override func setUp() {
        super.setUp()
        
        locationManager = LocationManagerMock()
        viewModel = DistrictListViewModel(locationManager: locationManager)
    }
    
    func testFetchFirstPage() async throws {
        // Given
        
        
        // When
        try await viewModel.fetchFirstPage()
        
        // Then
        XCTAssertEqual(viewModel.districts.count, 10)
        XCTAssertEqual(
            viewModel.districts.first,
            District.mock(
                name: "Praha 6",
                id: 17,
                slug: "praha-6"
            )
        )
    }
}

final class LocationManagerMock: LocationManager {
    override var currentLocation: CLLocationCoordinate2D {
        .init(latitude: 50.10496, longitude: 14.38957)
    }
}
