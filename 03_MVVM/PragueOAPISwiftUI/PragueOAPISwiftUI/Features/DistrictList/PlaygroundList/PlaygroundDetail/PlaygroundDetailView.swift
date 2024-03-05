//
//  PlaygroundDetailView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI
import MapKit

struct PlaygroundDetailView: View {
    @State var viewModel: PlaygroundDetailViewModel
    
    // MARK: - Views
    
    var body: some View {
        ScrollView {
            contentView
        }
        .sheet(item: $viewModel.presentedPlace) { _ in
//            AddressMapView(place: $0) {
                // TODO:
//                viewModel.setPresentedPlace(nil)
//            }
        }
        .navigationTitle(viewModel.playground.properties.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            playgroundImage
            
            description
                .padding(.horizontal)
        }
    }
    
    var playgroundImage: some View {
        Rectangle()
            .frame(height: 250)
            .frame(maxWidth: .infinity)
            .overlay {
                AsyncImage(url: viewModel.playground.properties.image.url) {
                    $0
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(contentMode: .fill)
                    
                } placeholder: {
                    ProgressView()
                }
            }
            .clipped()
            .foregroundStyle(.gray)
    }
    
    var description: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                Text("Popis:")
                    .bold()
                Text(viewModel.playground.properties.content)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Poloha:")
                    .bold()
                
                if let place = viewModel.playground.place {
                    Button {
                        viewModel.setPresentedPlace(place)
                    } label: {
                        Text(viewModel.playground.properties.address.addressFormatted)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        PlaygroundDetailView(
//            playground: .init(
//                properties: .init(
//                    name: "Dejvice - Hadovka",
//                    image: .init(url: .init(string: "http://www.hristepraha.cz/images/img/5b32cbf9a9dc515aadceac62a2c231b3o.jpg")!),
//                    perex: "Nedaleko Vítězného náměstí můžete navštívit pěkný park s dětskými hřišti. Na své si mohou přijít nejen děti, ale i milovníci umění.",
//                    content: "Dětské hřiště (24) najdete v parku u stanice tramvaje Hadovka. Má 2 části. Oplocená slouží spíše menším dětem. Tvoří ji...",
//                    address: .init(addressFormatted: "Zavadilova, 16000 Hlavní město Praha-Dejvice"),
//                    id: 1
//                ),
//                geometry: .init(coordinates: [14.373285294, 50.098304749])
//            )
//        )
//    }
//}
