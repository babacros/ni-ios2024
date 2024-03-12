//
//  PlaygroundList.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct PlaygroundListView: View {
    @State var viewModel: PlaygroundListViewModel
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            contentView
        }
        .onAppear {
            viewModel.getPlaygrounds()
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            playgroundsList
                .padding()
        }
    }
    
    var playgroundsList: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.playgrounds, id: \.properties.id) {
                playgroundListCell(playground: $0)
            }
        }
    }
    
    func playgroundListCell(playground: Playground) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(playground.properties.name)
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(playground.properties.perex)
                
                Text(playground.properties.address.addressFormatted)
                if let location = playground.place?.location {
                    Label(
                        title: {
                            Text(viewModel.distanceFromCurrentLocation(for: location))
                        },
                        icon: {
                            Image(systemName: "flag.checkered")
                        }
                    )
                }
            }
            
            HStack {
                Button {
                    viewModel.onDetail(playground: playground)
                } label: {
                    Text("Detail")
                        .foregroundStyle(.pink)
                }
                .buttonStyle(.plain)
            }
            
            Divider()
        }
    }
    
}

//#Preview {
//    PlaygroundListView(districtID: "praha-4")
//}
