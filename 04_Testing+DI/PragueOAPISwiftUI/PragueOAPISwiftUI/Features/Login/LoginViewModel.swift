//
//  LoginViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

protocol LoginViewModeling {
    var text: String { get set }
    func onSave()
}

@Observable
final class LoginViewModel: LoginViewModeling {
    var text: String
    
    private let userManager: UserManaging
    
    // MARK: - Initialization
    
    init(userManager: UserManaging) {
        self.userManager = userManager
        text = LoginViewModel.Constants.myAPIKey
    }
    
    // MARK: - Public Interface
    
    func onSave() {
        userManager.login(apiKey: text)
    }
}

extension LoginViewModel {
    enum Constants {
        static let myAPIKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjUxNywiaWF0IjoxNzA5MzkyODA2LCJleHAiOjExNzA5MzkyODA2LCJpc3MiOiJnb2xlbWlvIiwianRpIjoiN2VlOTY3NDktMjMzMS00NGU3LWEwNTktNzZkZWYyZDFhOTA1In0.5k-fwhUKhVmuDEV090nXWOHONK-I5cgjyV54tzL-FXs"
    }
}
