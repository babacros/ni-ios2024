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
            
            self.parkingPlaces = try await ParkingAPIService.parkingPlaces(
                currentLocation: LocationManager().currentLocation
            )
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
