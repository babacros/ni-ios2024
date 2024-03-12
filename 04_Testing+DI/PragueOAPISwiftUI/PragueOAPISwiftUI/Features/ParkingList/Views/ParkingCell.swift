//
//  ParkingCell.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import SwiftUI

extension ParkingListView {
    struct ParkingCell: View {
        var place: ParkingPlace
        var onTogglesaved: () -> Void
        var onAddressTapped: (IdentifiablePlace) -> Void
        var isSaved = false
        
        init(
            place: ParkingPlace,
            isSaved: Bool,
            onTogglesaved: @escaping (() -> Void),
            onAddressTapped: @escaping (IdentifiablePlace) -> Void
        ) {
            self.place = place
            self.isSaved = isSaved
            self.onTogglesaved = onTogglesaved
            self.onAddressTapped = onAddressTapped
        }
        
        // MARK: - Body
        
        var body: some View {
            VStack(alignment: .leading, spacing: 1) {
                header
                    .padding(.bottom, 4)
                
                Text(place.parkingType)
                
                Text("Volná místa: ")
                    .bold()
                +
                Text(place.freeSpacesString)
                
                address
            }
        }
        
        var header: some View {
            HStack {
                Text(place.name)
                    .font(.headline)
                    .foregroundStyle(.pink)
                
                Spacer()
                
                Button {
                    onTogglesaved()
                } label: {
                    let iconName = isSaved ? "star.fill" : "star"
                    Image(systemName: iconName)
                        .foregroundStyle(.yellow)
                }
                .buttonStyle(.plain)
            }
        }
        
        @ViewBuilder
        var address: some View {
            if let location = place.location {
                Button {
                    onAddressTapped(location)
                } label: {
                    Text(place.address.addressFormatted)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct ParkingListView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingListView.ParkingCell(
            place: .init(
                id: 1,
                name: "Holešovice",
                numberOfFreePlaces: 51,
                totalNumberOfPlaces: 200,
                parkingType: "P+R parkoviště",
                address: .init(addressFormatted: "FIT"),
                location: nil
            ),
            isSaved: false,
            onTogglesaved: {},
            onAddressTapped: { _ in }
        )
        .previewLayout(.sizeThatFits)
    }
}
