//
//  DistrictListViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class DistrictListViewController: UIViewController {
    private let viewModel: DistrictListViewModel
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = DistrictListViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = DistrictListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Městské části"
    }
}

extension DistrictListViewController: DistrictListFlowDelegate {
    func onPlaygroundList(districtID: String) {
        let vc = PlaygroundListViewController(viewModel: .init(districtID: districtID))
        navigationController?.pushViewController(vc, animated: true)
    }
}
