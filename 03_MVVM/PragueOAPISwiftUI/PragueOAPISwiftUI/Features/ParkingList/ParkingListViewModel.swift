//
//  ParkingListViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

@Observable
final class ParkingListViewModel {
    // MARK: - Private properties
    
    private var savedPlaces: [Int] {
        get { UserDefaults.standard.value(forKey: "places") as? [Int] ?? [] }
        set { UserDefaults.standard.setValue(newValue, forKey: "places") }
    }
    private(set) var parkingPlaces: [ParkingPlace] = [] {
        didSet {
            setVisiblePlaces()
        }
    }
    private(set) var presentedParkingPlaces: [ParkingPlace] = []
    private(set) var isLoading = false
    
    // MARK: - Public properties
    
    let screenModes = Mode.allCases
    var selectedAddress: IdentifiablePlace?
    var selectedMode: Mode = .all {
        didSet {
            setVisiblePlaces()
        }
    }
    var isContentUnavailableViewPresented: Bool {
        presentedParkingPlaces.isEmpty
    }
    
    // MARK: - Helpers
    
    func selectAddress(_ address: IdentifiablePlace?) {
        selectedAddress = address
    }
    
    func isPlaceSaved(_ place: ParkingPlace) -> Bool {
        savedPlaces.contains(place.id)
    }
    
    func toggleSaved(for place: ParkingPlace) {
        var places = savedPlaces
        if places.contains(where: { $0 == place.id }) {
            places.removeAll { $0 == place.id }
        } else {
            places.append(place.id)
        }
        savedPlaces = places
        setVisiblePlaces()
    }
    
    func syncParkingPlaces() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            let currentLocation = LocationManager.shared.currentLocation
            let urlString = "https://api.golemio.cz/v1/parkings?latlng=\(currentLocation.latitude)%2C\(currentLocation.longitude)&range=50000&limit=10&offset=0"
            let url = URL(string: urlString)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = [
                "accept": "application/json; charset=utf-8",
                "X-Access-Token": (UserDefaults.standard.value(forKey: "apiKey") as? String) ?? ""
            ]
            
            print(
                "⬆️ "
                + url.absoluteString
            )
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            
            print(
                "⬇️ "
                + "[\(httpResponse?.statusCode ?? -1)]: " + url.absoluteString //+ "\n"
//                + String(data: data, encoding: .utf8)!
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
            presentedParkingPlaces = parkingPlaces.filter ({ savedPlaces.contains($0.id) })
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
