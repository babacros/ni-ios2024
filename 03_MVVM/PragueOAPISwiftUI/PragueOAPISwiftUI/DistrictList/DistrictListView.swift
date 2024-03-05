//
//  DistrictListView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct DistrictListView: View {
    @State var districts: [District] = []
    @State var isLoading = false
    @State var moreDataAvailable = true
    
    // MARK: - Views
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Městské části")
                .onAppear {
                    Task {
                        if districts.isEmpty {
                            try await fetchFirstPage()
                        }
                    }
                }
                .refreshable {
                    try? await fetchFirstPage()
                }
        }
    }
    
    var contentView: some View {
        Group {
            if isLoading && districts.isEmpty {
                ProgressView()
            } else {
                districtList
            }
        }
    }
    
    var districtList: some View {
        List {
            ForEach(districts, id: \.properties.id) {
                districtSection(district: $0)
            }
            
            if moreDataAvailable {
                ProgressView()
                    .onAppear {
                        Task {
                            try await fetchNextPage()
                        }
                    }
            }
        }
    }
    
    func districtSection(district: District) -> some View {
        Section {
            NavigationLink {
                PlaygroundListView(districtID: district.properties.slug)
            } label: {
                Label("Hřiště", systemImage: "figure.jumprope")
                    .foregroundStyle(.pink)
            }
            
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
    
    // MARK: - Helpers
    
    func getDistricts(offset: Int = 10) async throws -> [District] {
        defer { isLoading = false }
        isLoading = true
        let urlString = "https://api.golemio.cz/v2/citydistricts?latlng=50.10496%2C14.38957&range=50000&limit=10&offset=\(offset)"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json; charset=utf-8",
            "X-Access-Token": (UserDefaults.standard.value(forKey: "apiKey") as? String) ?? ""
        ]
        
        print(
            "⬆️ "
            + url.absoluteString
        )
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let httpResponse = response as? HTTPURLResponse
        
        print(
            "⬇️ "
            + "[\(httpResponse?.statusCode ?? -1)]: " + url.absoluteString //+ "\n"
//            + String(data: data, encoding: .utf8)!
        )
        
        let features = try? JSONDecoder().decode(Features<District>.self, from: data)
        print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
        return features?.features ?? []
    }
    
    func fetchFirstPage() async throws {
        districts = try await getDistricts(offset: districts.count)
    }
    
    func fetchNextPage() async throws {
        if !districts.isEmpty {
            try await Task.sleep(for: .seconds(0.3))
            let districts = try await getDistricts(offset: districts.count)
            moreDataAvailable = districts.count == 10
            let mergedDistricts = NSOrderedSet(array: self.districts + districts)
            self.districts = (mergedDistricts.array as? [District]) ?? []
        }
    }
}

extension DistrictListView {
    struct District: Decodable, Hashable {
        let properties: DistrictProperties
    }
    
    struct DistrictProperties: Decodable, Hashable {
        let name: String
        let id: Int
        let slug: String
    }
}

#Preview {
    DistrictListView()
}
