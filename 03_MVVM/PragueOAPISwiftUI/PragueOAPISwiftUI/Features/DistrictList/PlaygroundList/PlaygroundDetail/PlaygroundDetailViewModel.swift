//
//  PlaygroundDetailViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

protocol PlaygroundDetailFlowDelegate: NSObject {
    func onMap(location: IdentifiablePlace)
}

@Observable
final class PlaygroundDetailViewModel {
    let playground: Playground
    
    weak var delegate: PlaygroundDetailFlowDelegate?
    
    // MARK: - Initialization
    
    init(playground: Playground) {
        self.playground = playground
    }
    
    // MARK: - Helpers
    
    func setPresentedPlace(_ place: IdentifiablePlace) {
        delegate?.onMap(location: place)
    }
}
