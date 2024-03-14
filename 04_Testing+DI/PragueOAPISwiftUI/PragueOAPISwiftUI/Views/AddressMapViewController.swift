//
//  AddressMapViewController.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

final class AddressMapViewController: UIViewController {
    let place: IdentifiablePlace
    
    // MARK: - Initialization
    
    init(place: IdentifiablePlace) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = AddressMapView(place: place)
        let vc = UIHostingController(rootView: rootView)
        embedController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = place.name
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(onClose)
        )
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc
    func onClose() {
        dismiss(animated: true)
    }
}
