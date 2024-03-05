//
//  ParkingListViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

protocol ParkingListDelegate: NSObject {
    func onMap(location: IdentifiablePlace)
}

@Observable
final class ParkingListViewModel {
    // MARK: - Private properties
    
    private(set) var parkingPlaces: [ParkingPlace] = [] {
        didSet {
            setVisiblePlaces()
        }
    }
    private(set) var presentedParkingPlaces: [ParkingPlace] = []
    private(set) var isLoading = false
    
    
    // MARK: - Public properties
    
    let screenModes = Mode.allCases
    var selectedMode: Mode = .all {
        didSet {
            setVisiblePlaces()
        }
    }
    var isContentUnavailableViewPresented: Bool {
        presentedParkingPlaces.isEmpty
    }
    
    weak var delegate: ParkingListDelegate?
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Helpers
    
    func openMap(_ address: IdentifiablePlace) {
        delegate?.onMap(location: address)
    }
    
    func isPlaceSaved(_ place: ParkingPlace) -> Bool {
        UserManager.shared.savedParkingPlaces.contains(place.id)
    }
    
    func toggleSaved(for place: ParkingPlace) {
        UserManager.shared.toggleSaved(for: place)
        setVisiblePlaces()
    }
    
    func syncParkingPlaces() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            let currentLocation = LocationManager.shared.currentLocation
            var url = Network.Endpoint.parkings.url
            let queryItems = [
                URLQueryItem(name: "latlng", value: "\(currentLocation.latitude),\(currentLocation.longitude)"),
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
            
            let features = try? JSONDecoder().decode(Features<APIParkingPlace>.self, from: data)
            print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
            self.parkingPlaces = features?.features.compactMap {
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
    
    // MARK: - Private Helpers
    
    private func setVisiblePlaces() {
        switch selectedMode {
        case .all:
            presentedParkingPlaces = parkingPlaces
        case .saved:
            presentedParkingPlaces = parkingPlaces.filter ({ UserManager.shared.savedParkingPlaces.contains($0.id) })
        }
    }
}

extension ParkingListViewModel {
    enum Mode: CaseIterable {
        case all
        case saved
        
        var string: String {
            switch self {
            case .all:
                "Vše"
            case .saved:
                "Uložené"
            }
        }
    }
}
