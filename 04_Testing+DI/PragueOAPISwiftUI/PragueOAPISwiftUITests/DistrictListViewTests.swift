//
//  DistrictViewTests.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import XCTest
@testable import PragueOAPISwiftUI

final class DistrictListViewTests: XCTestCase {
    func testDistrictListView() throws {
        let district = District.mock(name: "Praha 6")
        let vm = DistrictListViewModel.Mock(
            districts: [district],
            moreDataAvailable: true,
            isProgressViewPresented: false
        )
        let view = DistrictListView(viewModel: vm)
        AssertSnapshot(view)
    }
    
    func testDistrictListViewContent_Previews() throws {
        AssertSnapshot(DistrictListViewContent_Previews.previews)
    }
    
    func testDistrictListViewLoading_Previews() throws {
        AssertSnapshot(DistrictListViewLoading_Previews.previews)
    }
}
