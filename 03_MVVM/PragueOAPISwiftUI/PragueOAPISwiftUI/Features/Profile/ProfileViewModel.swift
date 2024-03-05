//
//  ProfileViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

@Observable
final class ProfileViewModel {
    var apiKey: String? {
        get { UserDefaults.standard.string(forKey: "apiKey") }
        set { UserDefaults.standard.set(newValue, forKey: "apiKey") }
    }
    private var onLogout: () -> Void
    
    // MARK: - Initialization
    
    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }
    
    // MARK: - Helpers
    
    func logout() {
        apiKey = nil
        UserDefaults.standard.setValue([], forKey: "places")
        onLogout()
    }
}
