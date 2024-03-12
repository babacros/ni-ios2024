//
//  ParkingListView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct ParkingListView: View {
    @State var viewModel: ParkingListViewModeling
    
    // MARK: - Body
    
    var body: some View {
        Picker("Mode", selection: $viewModel.selectedMode) {
            ForEach(ParkingListViewModel.Mode.allCases, id: \.self) {
                Text($0.string)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        
        contentView
            .frame(maxHeight: .infinity)
            .onAppear {
                viewModel.syncParkingPlaces()
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
                        onAddressTapped: { viewModel.openMap($0) }
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
