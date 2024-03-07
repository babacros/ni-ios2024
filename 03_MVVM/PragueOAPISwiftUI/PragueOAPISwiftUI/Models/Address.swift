//
//  Address.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation

struct Address: Decodable, Hashable {
    let addressFormatted: String
    
    enum CodingKeys: String, CodingKey {
        case addressFormatted = "address_formatted"
    }
}
