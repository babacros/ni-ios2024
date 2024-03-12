//
//  ProfileViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

protocol ProfileViewModeling {
    var apiKey: String? { get }
    func logout()
}

@Observable
final class ProfileViewModel: ProfileViewModeling {
    var apiKey: String? {
        userManager.apiKey
    }
    
    private let userManager: UserManaging
    
    // MARK: - Initialization
    
    init(userManager: UserManaging) {
        self.userManager = userManager
    }
    
    // MARK: - Public Interface
    
    func logout() {
        userManager.logout()
    }
}
