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
        userManager.apiKey
    }
    
    private let userManager = UserManager.shared
    
    // MARK: - Initialization
    
    init() {
        
    }

    // MARK: - Helpers
    
    func logout() {
        userManager.logout()
    }
}
