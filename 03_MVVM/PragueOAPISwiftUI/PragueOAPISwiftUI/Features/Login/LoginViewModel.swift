//
//  LoginViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

protocol LoginFlowDelegate: NSObject {
    func onLogin()
}

@Observable
final class LoginViewModel {
    var apiKey: String? {
        get { UserDefaults.standard.string(forKey: "apiKey") }
        set { UserDefaults.standard.set(newValue, forKey: "apiKey") }
    }
    
    var text: String
    weak var delegate: LoginFlowDelegate?
    
    // MARK: - Initialization
    
    init(delegate: LoginFlowDelegate) {
        self.delegate = delegate
        text = LoginViewModel.Constants.myAPIKey
    }
    
    // MARK: - Helpers
    
    func onSave() {
        apiKey = text
        delegate?.onLogin()
    }
}

extension LoginViewModel {
    enum Constants {
        static let myAPIKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjUxNywiaWF0IjoxNzA5MzkyODA2LCJleHAiOjExNzA5MzkyODA2LCJpc3MiOiJnb2xlbWlvIiwianRpIjoiN2VlOTY3NDktMjMzMS00NGU3LWEwNTktNzZkZWYyZDFhOTA1In0.5k-fwhUKhVmuDEV090nXWOHONK-I5cgjyV54tzL-FXs"
    }
}
