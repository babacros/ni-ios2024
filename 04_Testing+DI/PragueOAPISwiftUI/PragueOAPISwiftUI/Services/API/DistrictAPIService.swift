//
//  DistrictAPIService.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
import CoreLocation

protocol DistrictAPIServicing {
    func districts(
        currentLocation: CLLocationCoordinate2D,
        offset: Int
    ) async throws -> [District]
    
    func playgrounds(districtID: String) async throws -> [Playground]
}

class DistrictAPIService: DistrictAPIServicing {
    private let network: Networking
    
    // MARK: - Initialization
    
    init(network: Networking) {
        self.network = network
    }
    
    // MARK: - Public Interface
    
    func districts(
        currentLocation: CLLocationCoordinate2D,
        offset: Int
    ) async throws -> [District] {
        var url = Network.Endpoint.citydistricts.url
        let queryItems = [
            URLQueryItem.latlng(currentLocation),
            .range(),
            .limit(),
            .offset(offset)
        ]
        url.queryItems = queryItems
        
        let data = try await network.performRequest(
            url: url.url!,
            httpMethod: .GET,
            headers: Network.acceptJSONHeader
        )
        
        let features = try? JSONDecoder().decode(Features<District>.self, from: data)
        print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
        return features?.features ?? []
    }
    
    func playgrounds(districtID: String) async throws -> [Playground] {
        var url = Network.Endpoint.playgrounds.url
        let queryItems = [
            URLQueryItem(name: "districts", value: districtID),
            .range(),
            .limit(),
            .offset()
        ]
        url.queryItems = queryItems
        
        let data = try await network.performRequest(
            url: url.url!,
            httpMethod: .GET,
            headers: Network.acceptJSONHeader
        )
        
        let features = try? JSONDecoder().decode(Features<Playground>.self, from: data)
        print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
        return features?.features ?? []
    }
}
