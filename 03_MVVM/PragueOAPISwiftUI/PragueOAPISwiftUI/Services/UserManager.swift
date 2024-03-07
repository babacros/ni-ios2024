//
//  UserManager.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation

protocol UserManagerFlowDelegate: NSObject {
    func onLogin()
    func onLogout()
}

final class UserManager {
    static let shared = UserManager()
    private init() { }
    
    weak var delegate: UserManagerFlowDelegate?
    
    var savedParkingPlaces: [Int] {
        get { UserDefaults.standard.value(forKey: "places") as? [Int] ?? [] }
        set { UserDefaults.standard.setValue(newValue, forKey: "places") }
    }
    var apiKey: String? {
        get { UserDefaults.standard.string(forKey: "apiKey") }
        set { UserDefaults.standard.set(newValue, forKey: "apiKey") }
    }
    var isLoggedIn: Bool {
        !(apiKey ?? "").isEmpty
    }
    
    func login(apiKey: String) {
        self.apiKey = apiKey
        delegate?.onLogin()
    }
    
    func logout() {
        self.apiKey = nil
        UserDefaults.standard.setValue([], forKey: "places")
        delegate?.onLogout()
    }
    
    func toggleSaved(for place: ParkingPlace) {
        var places = savedParkingPlaces
        if places.contains(where: { $0 == place.id }) {
            places.removeAll { $0 == place.id }
        } else {
            places.append(place.id)
        }
        savedParkingPlaces = places
    }
}
