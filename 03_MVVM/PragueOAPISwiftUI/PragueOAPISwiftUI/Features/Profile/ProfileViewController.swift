//
//  ProfileViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class ProfileViewController: UIViewController {
    let viewModel: ProfileViewModel = .init()
    
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
