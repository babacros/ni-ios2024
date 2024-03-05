//
//  DistrictListViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation

@Observable
final class DistrictListViewModel {
    private(set) var districts: [District] = []
    private(set) var isLoading = false
    private(set) var moreDataAvailable = true
    var isProgressViewPresented: Bool {
        isLoading && districts.isEmpty
    }
    
    // MARK: - Helpers
    
    func onAppearFetch() {
        Task {
            if districts.isEmpty {
                try await fetchFirstPage()
            }
        }
    }
    
    func fetchFirstPage() async throws {
        districts = try await getDistricts(offset: 0)
    }
    
    func fetchNextPage() {
        Task {
            if !districts.isEmpty {
                try await Task.sleep(for: .seconds(0.3))
                let districts = try await getDistricts(offset: districts.count)
                moreDataAvailable = districts.count == 10
                let mergedDistricts = NSOrderedSet(array: self.districts + districts)
                self.districts = (mergedDistricts.array as? [District]) ?? []
            }
        }
    }
    
    // MARK: - Private helpers
    
    private func getDistricts(offset: Int = 10) async throws -> [District] {
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
}
