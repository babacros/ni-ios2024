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
            
            var url = Network.Endpoint.playgrounds.url
            let queryItems = [
                URLQueryItem(name: "districts", value: districtID),
                .init(name: "range", value: "50000"),
                .init(name: "limit", value: "10"),
                .init(name: "offset", value: "0")
            ]
            url.queryItems = queryItems
            
            let data = try await Network.shared.performRequest(
                url: url.url!,
                httpMethod: .GET,
                headers: Network.acceptJSONHeader
            )
            
            let features = try? JSONDecoder().decode(Features<Playground>.self, from: data)
            print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
            self.playgrounds = features?.features ?? []
        }
    }
    
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> String {
        String(LocationManager.shared.distanceFromCurrentLocation(for: location)) + "m"
    }
}
