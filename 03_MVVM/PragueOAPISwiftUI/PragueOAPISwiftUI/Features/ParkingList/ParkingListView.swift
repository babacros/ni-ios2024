//
//  ParkingListView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct ParkingListView: View {
    @State var viewModel: ParkingListViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Picker("Mode", selection: $viewModel.selectedMode) {
                ForEach(viewModel.screenModes, id: \.self) {
                    Text($0.string)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            contentView
                .frame(maxHeight: .infinity)
                .sheet(item: $viewModel.selectedAddress) {
                    AddressMapView(place: $0) {
                        viewModel.selectAddress(nil)
                    }
                }
                .navigationTitle("Parkovací místa")
                .onAppear {
                    viewModel.syncParkingPlaces()
                }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            ProgressView()
        } else if viewModel.isContentUnavailableViewPresented {
            ContentUnavailableView(
                label: {
                    Text("Žádná parkovací místa")
                }
            )
        } else {
            List {
                ForEach(viewModel.presentedParkingPlaces) { place in
                    ParkingCell(
                        place: place,
                        isSaved: viewModel.isPlaceSaved(place),
                        onTogglesaved: { viewModel.toggleSaved(for: place) },
                        onAddressTapped: { viewModel.selectAddress($0) }
                    )
                }
            }
        }
    }
}
//
//#Preview {
//    ParkingListView(
//        parkingPlaces: [
//            .init(
//                id: 1,
//                name: "Holešovice",
//                numberOfFreePlaces: 51,
//                totalNumberOfPlaces: 200,
//                parkingType: "P+R parkoviště",
//                address: .init(addressFormatted: "FIT"),
//                location: nil
//            ),
//            .init(
//                id: 1,
//                name: "Holešovice",
//                numberOfFreePlaces: 51,
//                totalNumberOfPlaces: 200,
//                parkingType: "P+R parkoviště",
//                address: .init(addressFormatted: "FIT"),
//                location: nil
//            )
//        ]
//    )
//}
//
//#Preview {
//    ParkingListView(
//        parkingPlaces: []
//    )
//}
