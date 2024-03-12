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
            dependencies: .init(
                districtAPIService: districtAPIService,
                locationManager: locationManager
            )
        )
    }
    
    func testFetchFirstPage() async throws {
        // Given
        let district = District.mock(
            name: "Praha 6",
            id: 17,
            slug: "praha-6"
        )
        let currentLocation = CLLocationCoordinate2D(latitude: 50.10496, longitude: 14.38957)
        
        locationManager.currentLocationReturnValue = currentLocation
        
        districtAPIService.districtsReturnValue = [district]
        var retrievedCurrentLocation: CLLocationCoordinate2D?
        var retrievedOffset: Int?
        districtAPIService.onDistricts = {
            retrievedCurrentLocation = $0
            retrievedOffset = $1
        }
        
        // When
        try await viewModel.fetchFirstPage()
        
        // Then
        XCTAssertEqual(viewModel.districts.count, 1)
        XCTAssertEqual(
            viewModel.districts.first,
            district
        )
        XCTAssertEqual(retrievedCurrentLocation?.latitude, currentLocation.latitude)
        XCTAssertEqual(retrievedCurrentLocation?.longitude, currentLocation.longitude)
        XCTAssertEqual(retrievedOffset, 0)
    }
}
