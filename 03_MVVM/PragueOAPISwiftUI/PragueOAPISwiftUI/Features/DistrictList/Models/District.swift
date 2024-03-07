//
//  District.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation

struct District: Decodable, Hashable {
    let properties: DistrictProperties
}

extension District {
    struct DistrictProperties: Decodable, Hashable {
        let name: String
        let id: Int
        let slug: String
    }
}
