//
//  PragueOAPISwiftUIApp.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

/// https://api.golemio.cz/docs/openapi/
/// https://api.golemio.cz/api-keys/dashboard
//@main
//struct PragueOAPISwiftUIApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .tint(.pink)
//        }
//    }
//}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
