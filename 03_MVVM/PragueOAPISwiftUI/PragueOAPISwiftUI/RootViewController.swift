//
//  ContentView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

final class RootViewController: UIViewController {
    private weak var loginViewController: UINavigationController!
    private weak var tabBar: UITabBarController!
    
    // MARK: - Controller lifecycle
       
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        // MARK: Login
        
        let loginViewController = LoginViewController(
            viewModel: .init(
                delegate: self
            )
        )
        let loginNavigationController = UINavigationController(
            rootViewController: loginViewController
        )
        embedController(loginNavigationController)
        self.loginViewController = loginNavigationController
        
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
        
        let profileVC = ProfileViewController(
            viewModel: .init(
                onLogout: { [weak self] in self?.updateAppState() }
            )
        )
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        updateAppState()
    }

    // MARK: - Private helpers
    
    private func updateAppState() {
        if let _ = UserDefaults.standard.value(forKey: "apiKey") {
            loginViewController.view.isHidden = true
            tabBar.selectedIndex = 0
            tabBar?.view.isHidden = false
        } else {
            loginViewController.view.isHidden = false
            tabBar?.view.isHidden = true
        }
    }
}

extension RootViewController: LoginFlowDelegate {
    func onLogin() {
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
