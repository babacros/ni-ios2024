//
//  PlaygroundDetailViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class PlaygroundDetailViewController: UIViewController {
    private let viewModel: PlaygroundDetailViewModel
    
    // MARK: - Initialization
    
    init(viewModel: PlaygroundDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = PlaygroundDetailView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        navigationItem.title = viewModel.playground.properties.name
    }
}

extension PlaygroundDetailViewController: PlaygroundDetailFlowDelegate {
    func onMap(location: IdentifiablePlace) {
        let vc = AddressMapViewController(place: location)
        let navVC = UINavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: true)
    }
}
