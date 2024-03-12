//
//  LoginViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = LoginView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Přihlášení"
    }
}
