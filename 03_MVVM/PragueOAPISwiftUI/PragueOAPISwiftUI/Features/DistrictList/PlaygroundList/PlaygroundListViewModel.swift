//
//  PlaygroundListViewModel.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 05.03.2024.
//

import Foundation
import Observation
import MapKit

protocol PlaygroundListFlowDelegate: NSObject {
    func onDetail(playground: Playground)
}

@Observable
final class PlaygroundListViewModel {
    private let districtID: String
    
    private(set) var playgrounds: [Playground] = []
    private(set) var isLoading = false
    
    weak var delegate: PlaygroundListFlowDelegate?
    
    // MARK: - Initialization
    
    init(districtID: String) {
        self.districtID = districtID
    }
    
    // MARK: - Helpers
    
    func onDetail(playground: Playground) {
        delegate?.onDetail(playground: playground)
    }
    
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
                + url.absoluteString
            )
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            
            print(
                "⬇️ "
                + "[\(httpResponse?.statusCode ?? -1)]: " + url.absoluteString + "\n"
                + String(data: data, encoding: .utf8)!
            )
            
            let features = try? JSONDecoder().decode(Features<Playground>.self, from: data)
            print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
            self.playgrounds = features?.features ?? []
        }
    }
    
    func distanceFromCurrentLocation(for location: CLLocationCoordinate2D) -> String {
        String(LocationManager.shared.distanceFromCurrentLocation(for: location)) + "m"
    }
}
