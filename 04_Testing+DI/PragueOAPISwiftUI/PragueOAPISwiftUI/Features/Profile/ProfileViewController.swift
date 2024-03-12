//
//  ProfileViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class ProfileViewController: UIViewController {
    let viewModel: ProfileViewModeling
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = ProfileViewModel(
            userManager: UserManager()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = ProfileView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profil"
        let logoutButton = UIBarButtonItem(
            title: "Odhlásit se",
            style: .plain,
            target: self,
            action: #selector(onLogout)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc
    func onLogout() {
        viewModel.logout()
    }
}
