//
//  AddressMapView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI
import MapKit

struct AddressMapView: View {
    let place: IdentifiablePlace
    var onClose: () -> Void
    
    // MARK: - Views
    
    var body: some View {
        NavigationStack {
            contentView
                .toolbar(content: {
                    ToolbarItem(
                        placement: .navigation,
                        content: {
                            Button {
                                onClose()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    )
                })
                .tint(.pink)
                .navigationTitle(place.name)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var contentView: some View {
        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    center: place.location,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.005,
                        longitudeDelta: 0.005
                    )
                )
            )
        ) {
            Marker("", coordinate: place.location)
                .tint(.orange)
        }
    }
}

#Preview {
    AddressMapView(
        place: .init(
            name: "Name",
            lat: 50.10496,
            lon: 14.38957
        ),
        onClose: {}
    )
}
