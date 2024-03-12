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
    lazy var districtAPIService: DistrictAPIServicing = DistrictAPIService(
        network: network
    )
    lazy var network: Networking = Network()
}

extension AppDependency: HasDistrictAPIService { }
extension AppDependency: HasNetwork { }
extension AppDependency: HasLocationManager { }
