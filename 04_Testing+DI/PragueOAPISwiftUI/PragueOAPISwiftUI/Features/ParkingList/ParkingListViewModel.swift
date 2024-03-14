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

protocol ParkingListViewModeling {
    var delegate: ParkingListDelegate? { get set }
    
    var parkingPlaces: [ParkingPlace] { get }
    var presentedParkingPlaces: [ParkingPlace] { get }
    var isLoading: Bool { get }
    var selectedMode: ParkingListViewModel.Mode { get set }
    var isContentUnavailableViewPresented: Bool { get }
    
    func openMap(_ address: IdentifiablePlace)
    func isPlaceSaved(_ place: ParkingPlace) -> Bool
    func toggleSaved(for place: ParkingPlace)
    func syncParkingPlaces()
}

@Observable
final class ParkingListViewModel: ParkingListViewModeling {
    struct Dependencies: HasUserManager, HasLocationManager, HasParkingAPIService {
        let userManager: UserManaging
        let parkingAPIService: ParkingAPIServicing
        let locationManager: LocationManaging
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
    var selectedMode: Mode = .all {
        didSet {
            setVisiblePlaces()
        }
    }
    var isContentUnavailableViewPresented: Bool {
        presentedParkingPlaces.isEmpty
    }
    
    weak var delegate: ParkingListDelegate?
    
    let userManager: UserManaging
    private let locationManager: LocationManaging
    let parkingAPIService: ParkingAPIServicing
    
    // MARK: - Initialization
    
    init(dependencies: Dependencies) {
        userManager = dependencies.userManager
        locationManager = dependencies.locationManager
        parkingAPIService = dependencies.parkingAPIService
    }
    
    // MARK: - Helpers
    
    func openMap(_ address: IdentifiablePlace) {
        delegate?.onMap(location: address)
    }
    
    func isPlaceSaved(_ place: ParkingPlace) -> Bool {
        userManager.savedParkingPlaces.contains(place.id)
    }
    
    func toggleSaved(for place: ParkingPlace) {
        userManager.toggleSaved(for: place)
        setVisiblePlaces()
    }
    
    func syncParkingPlaces() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            self.parkingPlaces = try await parkingAPIService.parkingPlaces(
                currentLocation: locationManager.currentLocation
            )
        }
    }
    
    // MARK: - Private Helpers
    
    private func setVisiblePlaces() {
        switch selectedMode {
        case .all:
            presentedParkingPlaces = parkingPlaces
        case .saved:
            presentedParkingPlaces = parkingPlaces.filter ({ [weak self] in self?.userManager.savedParkingPlaces.contains($0.id) ?? false
            })
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
