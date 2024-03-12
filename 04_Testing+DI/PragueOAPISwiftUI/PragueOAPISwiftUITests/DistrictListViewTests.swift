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
}

extension DistrictListViewModel {
    final class Mock: DistrictListViewModeling {
        var delegate: PragueOAPISwiftUI.DistrictListFlowDelegate? = nil
        var districts: [District] = []
        var moreDataAvailable: Bool = false
        var isProgressViewPresented: Bool = false
        
        init(
            districts: [District],
            moreDataAvailable: Bool,
            isProgressViewPresented: Bool
        ) {
            self.districts = districts
            self.moreDataAvailable = moreDataAvailable
            self.isProgressViewPresented = isProgressViewPresented
        }
        
        func onPresentPlaygroundList(districtID: String) {}
        func onAppearFetch() {}
        func fetchFirstPage() async throws {}
        func fetchNextPage() {}
    }
}
