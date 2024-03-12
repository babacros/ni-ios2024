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

@Observable
final class PlaygroundListViewModel {
    private let districtID: String
    
    private(set) var playgrounds: [Playground] = []
    private(set) var isLoading = false
    
    weak var delegate: PlaygroundListFlowDelegate?
    
    // MARK: - Initialization
    
    init(districtID: String) {
        self.districtID = districtID
    }
    
    // MARK: - Helpers
    
    func onDetail(playground: Playground) {
        delegate?.onDetail(playground: playground)
    }
    
    func getPlaygrounds() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            self.playgrounds = try await DistrictAPIService().playgrounds(
                districtID: districtID
            )
        }
    }
    
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> String {
        String(LocationManager().distanceFromCurrentLocation(for: location)) + "m"
    }
}
