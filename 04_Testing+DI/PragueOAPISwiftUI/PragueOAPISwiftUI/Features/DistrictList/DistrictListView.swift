//
//  DistrictListView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct DistrictListView: View {
    @State var viewModel: DistrictListViewModeling
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .onAppear {
                viewModel.onAppearFetch()
            }
            .refreshable {
                try? await viewModel.fetchFirstPage()
            }
    }
    
    var contentView: some View {
        Group {
            if viewModel.isProgressViewPresented {
                ProgressView()
            } else {
                districtList
            }
        }
    }
    
    var districtList: some View {
        List {
            ForEach(viewModel.districts, id: \.properties.id) {
                districtSection(district: $0)
            }
            
            if viewModel.moreDataAvailable {
                ProgressView()
                    .onAppear {
                        viewModel.fetchNextPage()
                    }
            }
        }
    }
    
    func districtSection(district: District) -> some View {
        Section {
            Button {
                viewModel.onPresentPlaygroundList(
                    districtID: district.properties.slug
                )
            } label: {
                Label("Hřiště", systemImage: "figure.jumprope")
                    .foregroundStyle(.pink)
            }
            .buttonStyle(.plain)
            
            NavigationLink {
                Text("TODO:")
            } label: {
                Label("Parky", systemImage: "tree")
                    .foregroundStyle(.green)
            }
            
            NavigationLink {
                Text("TODO:")
            } label: {
                Label("Odpad", systemImage: "trash")
                    .foregroundStyle(.yellow)
            }
            
            NavigationLink {
                Text("TODO:")
            } label: {
                Label("Zdraví", systemImage: "stethoscope")
                    .foregroundStyle(.purple)
            }
            
            Link(
                destination: URL(
                    string: "https://www.ackee.cz"
                )!
            ) {
                Label("Web", systemImage: "globe")
                    .foregroundStyle(.blue)
            }
            .tint(.blue)
        } header: {
            Text(district.properties.name)
                .font(.headline)
        }
    }
}

//#Preview {
//    DistrictListView()
//}

struct DistrictListViewContent_Previews: PreviewProvider {
    static var previews: some View {
        DistrictListView(
            viewModel: DistrictListViewModel.Mock(
                districts: [.mock()]
            )
        )
        .previewLayout(.sizeThatFits)
    }
}

struct DistrictListViewLoading_Previews: PreviewProvider {
    static var previews: some View {
        DistrictListView(
            viewModel: DistrictListViewModel.Mock(
                isProgressViewPresented: true
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
