//
//  DistrictListViewModelTests.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import XCTest
@testable import PragueOAPISwiftUI

final class DistrictListViewModelTests: XCTestCase {
    func testFetchFirstPage() async throws {
        // Given
        let viewModel = DistrictListViewModel()
        
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
