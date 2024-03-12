//
//  AppDependency.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation

let appDependencies = AppDependency()

final class AppDependency {
    lazy var locationManager: LocationManaging = LocationManager()
    lazy var userManager: UserManaging = UserManager()
    lazy var districtAPIService: DistrictAPIServicing = DistrictAPIService(
        dependencies: .init(network: network)
    )
    lazy var parkingAPIService: ParkingAPIServicing = ParkingAPIService(
        dependencies: .init(network: network)
    )
    lazy var network: Networking = Network()
}

extension AppDependency: HasDistrictAPIService { }
extension AppDependency: HasNetwork { }
extension AppDependency: HasLocationManager { }
extension AppDependency: HasParkingAPIService { }
extension AppDependency: HasUserManager { }
