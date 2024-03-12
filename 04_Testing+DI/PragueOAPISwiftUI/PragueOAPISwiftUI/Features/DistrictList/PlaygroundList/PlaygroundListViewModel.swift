//
//  PlaygroundListViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation
import MapKit

protocol PlaygroundListFlowDelegate: NSObject {
    func onDetail(playground: Playground)
}

protocol PlaygroundListViewModeling {
    var playgrounds: [Playground] { get }
    var isLoading: Bool { get }
    
    // Not nice - gonna be fixed during 5. lecture
    var delegate: PlaygroundListFlowDelegate? { get set }
 
    func onDetail(playground: Playground)
    func getPlaygrounds()
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> String
}

@Observable
final class PlaygroundListViewModel: PlaygroundListViewModeling {
    struct Dependencies: HasDistrictAPIService {
        let districtAPIService: DistrictAPIServicing
    }
    
    private let districtID: String
    
    private(set) var playgrounds: [Playground] = []
    private(set) var isLoading = false
    
    weak var delegate: PlaygroundListFlowDelegate?
    
    private let districtAPIService: DistrictAPIServicing
    
    // MARK: - Initialization
    
    init(
        districtID: String,
        dependencies: Dependencies
    ) {
        self.districtID = districtID
        districtAPIService = dependencies.districtAPIService
    }
    
    // MARK: - Public Interface
    
    func onDetail(playground: Playground) {
        delegate?.onDetail(playground: playground)
    }
    
    func getPlaygrounds() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            self.playgrounds = try await districtAPIService.playgrounds(
                districtID: districtID
            )
        }
    }
    
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> String {
        String(LocationManager().distanceFromCurrentLocation(for: location)) + "m"
    }
}
