//
//  ContentView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

final class RootViewController: UIViewController {
    private weak var loginViewController: UINavigationController!
    private weak var tabBar: UITabBarController?
    
    private var userManager: UserManaging
    
    init() {
        userManager = UserManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
       
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        // MARK: Login
        
        let loginViewController = LoginViewController()
        let loginNavigationController = UINavigationController(
            rootViewController: loginViewController
        )
        embedController(loginNavigationController)
        self.loginViewController = loginNavigationController
        
        setupTabBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        userManager.delegate = self
        
        updateAppState()
    }

    // MARK: - Private helpers
    
    private func setupTabBar() {
        guard tabBar == nil, userManager.isLoggedIn else { return }
        // MARK: DistrictList
        
        let districtListVC = DistrictListViewController()
        let districtListNavigationController = UINavigationController(
            rootViewController: districtListVC
        )
        districtListNavigationController.tabBarItem.title = "Městské části"
        districtListNavigationController.tabBarItem.image = UIImage(
            systemName: "house.and.flag"
        )
        
        // MARK: ParkingList
        
        let parkingListVC = ParkingListViewController()
        let parkingListNavigationController = UINavigationController(
            rootViewController: parkingListVC
        )
        parkingListNavigationController.tabBarItem.title = "Parkování"
        parkingListNavigationController.tabBarItem.image = UIImage(
            systemName: "parkingsign.radiowaves.left.and.right"
        )
        
        // MARK: Profile
        
        let profileVC = ProfileViewController()
        let profileNavigationController = UINavigationController(
            rootViewController: profileVC
        )
        profileNavigationController.tabBarItem.title = "Profil"
        profileNavigationController.tabBarItem.image = UIImage(
            systemName: "person"
        )
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            districtListNavigationController,
            parkingListNavigationController,
            profileNavigationController
        ]
        embedController(tabBarController)
        
        self.tabBar = tabBarController
    }
    
    private func updateAppState() {
        if userManager.isLoggedIn {
            loginViewController.view.isHidden = true
            tabBar?.view.isHidden = false
            tabBar?.selectedIndex = 0
        } else {
            loginViewController.view.isHidden = false
            tabBar?.view.isHidden = true
        }
    }
}

extension RootViewController: UserManagerFlowDelegate {
    func onLogin() {
        updateAppState()
        setupTabBar()
    }
    
    func onLogout() {
        updateAppState()
    }
}

#Preview {
    RootViewController()
}

//struct ContentView: View {
//    @AppStorage("apiKey") var apiKey: String?
//    
//    var body: some View {
//        if (apiKey ?? "").isEmpty {
//            LoginView(viewModel: .init())
//        } else {
//            tabView
//        }
//    }
//    
//    var tabView: some View {
//        TabView {
//            DistrictListView()
//                .tabItem {
//                    Label(
//                        title: { Text("Městské části") },
//                        icon: { Image(systemName: "house.and.flag") }
//                    )
//                }
//            
//            ParkingListView(viewModel: .init())
//                .tabItem {
//                    Label(
//                        title: { Text("Parkování") },
//                        icon: { Image(systemName: "parkingsign.radiowaves.left.and.right") }
//                    )
//                }
//            
//            ProfileView(
//                viewModel: .init(
//                    onLogout: { }
//                )
//            )
//            .tabItem {
//                Label(
//                    title: { Text("Profil") },
//                    icon: { Image(systemName: "person") }
//                )
//            }
//        }
//    }
//}
