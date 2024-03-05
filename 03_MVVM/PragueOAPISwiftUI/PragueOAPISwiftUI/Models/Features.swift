//
//  Features.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import Foundation

struct Features<I: Decodable>: Decodable {
    let features: [I]
}
