//
//  ParkingAPIService.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import CoreLocation

protocol HasParkingAPIService {
    var parkingAPIService: ParkingAPIServicing { get }
}

protocol ParkingAPIServicing {
    func parkingPlaces(
        currentLocation: CLLocationCoordinate2D
    ) async throws -> [ParkingPlace]
}

final class ParkingAPIService: ParkingAPIServicing {
    struct Dependencies: HasNetwork {
        let network: Networking
    }
    
    private let network: Networking
    
    // MARK: - Initialization
    
    init(dependencies: Dependencies) {
        network = dependencies.network
    }
    
    // MARK: - Public Interface
    
    func parkingPlaces(
        currentLocation: CLLocationCoordinate2D
    ) async throws -> [ParkingPlace] {
        var url = Network.Endpoint.parkings.url
        let queryItems = [
            URLQueryItem.latlng(currentLocation),
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
        
        let features = try? JSONDecoder().decode(Features<APIParkingPlace>.self, from: data)
        print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
        
        return features?.features.compactMap {
            let properties = $0.properties
            let coordinatesTupple = $0.geometry.coordinatesTupple
            return ParkingPlace(
                id: properties.id,
                name: properties.name,
                numberOfFreePlaces: properties.numberOfFreePlaces,
                totalNumberOfPlaces: properties.totalNumberOfPlaces,
                parkingType: properties.parkingType.description,
                address: properties.address,
                location: .init(
                    name: properties.name,
                    lat: coordinatesTupple.lat,
                    lon: coordinatesTupple.lon
                )
            )
        } ?? []
    }
}
