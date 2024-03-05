//
//  PlaygroundDetailViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

@Observable
final class PlaygroundDetailViewModel {
    let playground: Playground
    var presentedPlace: IdentifiablePlace?
    
    // MARK: - Initialization
    
    init(playground: Playground) {
        self.playground = playground
    }
    
    // MARK: - Helpers
    
    func setPresentedPlace(_ place: IdentifiablePlace?) {
        presentedPlace = place
    }
}
