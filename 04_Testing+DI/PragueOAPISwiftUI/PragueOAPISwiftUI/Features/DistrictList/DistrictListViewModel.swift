//
//  DistrictListViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

protocol DistrictListFlowDelegate: NSObject {
    func onPlaygroundList(districtID: String)
}

protocol DistrictListViewModeling {
    // Not nice - gonna be fixed during 5. lecture
    var delegate: DistrictListFlowDelegate? { get set }
    var districts: [District] { get }
    var moreDataAvailable: Bool { get }
    var isProgressViewPresented: Bool { get }
    
    func onPresentPlaygroundList(districtID: String)
    func onAppearFetch()
    func fetchFirstPage() async throws
    func fetchNextPage()
}

@Observable
final class DistrictListViewModel: DistrictListViewModeling {
    struct Dependencies: HasDistrictAPIService, HasLocationManager {
        let districtAPIService: DistrictAPIServicing
        let locationManager: LocationManaging
    }
    private var isLoading = false
    private(set) var districts: [District] = []
    private(set) var moreDataAvailable = true
    var isProgressViewPresented: Bool {
        isLoading && districts.isEmpty
    }
    
    weak var delegate: DistrictListFlowDelegate?
    
    private let locationManager: LocationManaging
    private let districtAPIService: DistrictAPIServicing
    
    // MARK: - Initialization
    
    init(dependencies: Dependencies) {
        locationManager = dependencies.locationManager
        districtAPIService = dependencies.districtAPIService
    }
    
    // MARK: - Helpers
    
    func onPresentPlaygroundList(districtID: String) {
        delegate?.onPlaygroundList(districtID: districtID)
    }
    
    func onAppearFetch() {
        Task {
            if districts.isEmpty {
                try await fetchFirstPage()
            }
        }
    }
    
    func fetchFirstPage() async throws {
        districts = try await getDistricts(offset: 0)
    }
    
    func fetchNextPage() {
        Task {
            if !districts.isEmpty {
                try await Task.sleep(for: .seconds(0.3))
                let districts = try await getDistricts(offset: districts.count)
                moreDataAvailable = districts.count == 10
                let mergedDistricts = NSOrderedSet(array: self.districts + districts)
                self.districts = (mergedDistricts.array as? [District]) ?? []
            }
        }
    }
    
    // MARK: - Private helpers
    
    private func getDistricts(offset: Int = 10) async throws -> [District] {
        defer { isLoading = false }
        isLoading = true
        
        return try await districtAPIService.districts(
            currentLocation: locationManager.currentLocation,
            offset: offset
        )
    }
}
