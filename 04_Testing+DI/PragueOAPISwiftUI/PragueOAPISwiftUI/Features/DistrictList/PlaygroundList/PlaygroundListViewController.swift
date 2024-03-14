//
//  PlaygroundListViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class PlaygroundListViewController: UIViewController {
    private var viewModel: PlaygroundListViewModeling
    
    // MARK: - Initialization
    
    init(viewModel: PlaygroundListViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = PlaygroundListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Hřiště"
    }
}

extension PlaygroundListViewController: PlaygroundListFlowDelegate {
    func onDetail(playground: Playground) {
        let vc = PlaygroundDetailViewController(viewModel: PlaygroundDetailViewModel(playground: playground))
        navigationController?.pushViewController(vc, animated: true)
    }
}
