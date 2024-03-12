//
//  ParkingListViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class ParkingListViewController: UIViewController {
    private let viewModel: ParkingListViewModel
    
    // MARK: - Initialization
    
    init() {
        self.viewModel = ParkingListViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = ParkingListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Parkovací místa"
    }
}

extension ParkingListViewController: ParkingListDelegate {
    func onMap(location: IdentifiablePlace) {
        let vc = AddressMapViewController(place: location)
        let navVC = UINavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: true)
    }
}
