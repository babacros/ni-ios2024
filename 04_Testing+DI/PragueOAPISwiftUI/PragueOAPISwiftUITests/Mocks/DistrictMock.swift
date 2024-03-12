//
//  DistrictMock.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import Foundation
@testable import PragueOAPISwiftUI

extension District {
    static func mock(
        name: String = "Name",
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
