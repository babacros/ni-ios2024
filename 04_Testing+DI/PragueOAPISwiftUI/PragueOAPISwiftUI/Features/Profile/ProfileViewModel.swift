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
    struct Dependencies: HasUserManager {
        let userManager: UserManaging
    }
    
    var apiKey: String? {
        userManager.apiKey
    }
    
    private let userManager: UserManaging
    
    // MARK: - Initialization
    
    init(dependencies: Dependencies) {
        userManager = dependencies.userManager
    }
    
    // MARK: - Public Interface
    
    func logout() {
        userManager.logout()
    }
}
