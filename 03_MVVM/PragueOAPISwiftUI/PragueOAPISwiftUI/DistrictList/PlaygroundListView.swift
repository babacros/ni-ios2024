//
//  PlaygroundList.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI
import MapKit

struct PlaygroundListView: View {
    let districtID: String
    
    @State var playgrounds: [Playground] = []
    @State var presentedPlace: IdentifiablePlace?
    @State var isLoading = false
    
    // MARK: - Views
    
    var body: some View {
        ScrollView {
            contentView
        }
        .navigationTitle("Hřiště")
        .onAppear {
            getPlaygrounds()
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if isLoading {
            ProgressView()
        } else {
            playgroundsList
                .padding()
        }
    }
    
    var playgroundsList: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(playgrounds, id: \.properties.id) {
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
                            Text(String(LocationManager.shared.distanceFromCurrentLocation(for: location)) + "m")
                        },
                        icon: {
                            Image(systemName: "flag.checkered")
                        }
                    )
                }
            }
            
            HStack {
                NavigationLink {
                    PlaygroundDetailView(playground: playground)
                } label: {
                    Text("Detail")
                }
            }
            
            Divider()
        }
    }
    
    // MARK: - Helpers
    
    func getPlaygrounds() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            let urlString = "https://api.golemio.cz/v2/playgrounds?&range=5000&districts=\(districtID)&limit=20&offset=0"
            let url = URL(string: urlString)!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = [
                "accept": "application/json; charset=utf-8",
                "X-Access-Token": (UserDefaults.standard.value(forKey: "apiKey") as? String) ?? ""
            ]
            
            print(
                "⬆️ "
                + url.absoluteString + "\n"
            )
            
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
                        
            let dataString = String(data: data, encoding: String.Encoding.utf8) ?? ""
            print(
                "⬇️ "
                + url.absoluteString + "\n"
                + dataString
            )
            
            let features = try? JSONDecoder().decode(Features<Playground>.self, from: data)
            self.playgrounds = features?.features ?? []
        }
    }
}

#Preview {
    PlaygroundListView(districtID: "praha-4")
}
