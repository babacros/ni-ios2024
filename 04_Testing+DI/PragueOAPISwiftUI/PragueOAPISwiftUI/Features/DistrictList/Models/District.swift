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

extension District {
    static func mock(
        name: String = "Praha X",
        id: Int = 0,
        slug: String = "Slug"
    ) -> District {
        District(
            properties: .init(
                name: name,
                id: id,
                slug: slug
            )
        )
    }
}
