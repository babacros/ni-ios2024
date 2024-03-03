//
//  ParkingListView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI
import MapKit

struct ParkingListView: View {
    enum Mode: CaseIterable {
        case all
        case favourite
        
        var string: String {
            switch self {
            case .all:
                "Vše"
            case .favourite:
                "Oblíbené"
            }
        }
    }
    
    @State var parkingPlaces: [ParkingPlace] = []
    @State var presentedParkingPlaces: [ParkingPlace] = []
    @State var selectedMode: Mode = .all
    @State var isLoading = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Picker("Mode", selection: $selectedMode) {
                ForEach(Mode.allCases, id: \.self) {
                    Text($0.string)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            contentView
                .frame(maxHeight: .infinity)
                .navigationTitle("Parkovací místa")
                .onAppear {
                    syncParkingPlaces()
                }
                .onChange(of: selectedMode) { _, _ in
                    setVisiblePlaces()
                }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if isLoading {
            ProgressView()
        } else if presentedParkingPlaces.isEmpty {
            ContentUnavailableView(
                label: {
                    Text("Žádná parkovací místa")
                }
            )
        } else {
            List {
                ForEach(presentedParkingPlaces) { place in
                    ParkingCell(place: place) {
                        setVisiblePlaces()
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func syncParkingPlaces() {
        Task {
            defer { isLoading = false }
            isLoading = true
            
            let currentLocation = LocationManager.shared.currentLocation
            let urlString = "https://api.golemio.cz/v1/parkings?latlng=\(currentLocation.latitude)%2C\(currentLocation.longitude)&range=50000&limit=10&offset=0"
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
            
            let features = try? JSONDecoder().decode(Features<APIParkingPlace>.self, from: data)
            let favouritesIds: [Int] = []
            self.parkingPlaces = features?.features.compactMap {
                let properties = $0.properties
                return ParkingPlace(
                    id: properties.id,
                    name: properties.name,
                    numberOfFreePlaces: properties.numberOfFreePlaces,
                    totalNumberOfPlaces: properties.totalNumberOfPlaces,
                    parkingType: properties.parkingType.description,
                    isFavourite: favouritesIds.contains(properties.id)
                )
            } ?? []
            setVisiblePlaces()
        }
    }
    
    func setVisiblePlaces() {
        switch selectedMode {
        case .all:
            presentedParkingPlaces = parkingPlaces
        case .favourite:
            let places = UserDefaults.standard.value(forKey: "places") as? [Int] ?? []
            presentedParkingPlaces = parkingPlaces.filter({ places.contains($0.id) })
        }
    }
}

extension ParkingListView {
    struct ParkingCell: View {
        var place: ParkingPlace
        var onToggleFavorite: () -> Void
        @State var isFavorite = false
        
        init(
            place: ParkingPlace,
            onToggleFavorite: @escaping (() -> Void)
        ) {
            self.place = place
            self.onToggleFavorite = onToggleFavorite
            isFavorite = place.isFavourite
        }
        
        // MARK: - Views
        
        var body: some View {
            VStack(alignment: .leading) {
                header
                
                Text("Typ: ")
                    .bold()
                +
                Text(place.parkingType)
                
                Text("Volná místa: ")
                    .bold()
                +
                Text(place.freeSpacesString)
            }
            .onAppear { checkFavorites() }
        }
        
        var header: some View {
            HStack {
                Text(place.name)
                
                Spacer()
                
                Button {
                    toggleFavorites()
                } label: {
                    let iconName = isFavorite ? "star.fill" : "star"
                    Image(systemName: iconName)
                }
                .tint(.yellow)
            }
        }
        
        func toggleFavorites() {
            var places = UserDefaults.standard.value(forKey: "places") as? [Int] ?? []
            if places.contains(where: { $0 == place.id }) {
                places.removeAll { $0 == place.id }
            } else {
                places.append(place.id)
            }
            UserDefaults.standard.setValue(places, forKey: "places")
            checkFavorites()
            onToggleFavorite()
        }
        
        func checkFavorites() {
            let places = UserDefaults.standard.value(forKey: "places") as? [Int] ?? []
            isFavorite = places.contains(place.id)
        }
    }
}

extension ParkingListView {
    struct ParkingPlace: Identifiable, Hashable {
        let id: Int
        let name: String
        let numberOfFreePlaces: Int
        let totalNumberOfPlaces: Int
        let parkingType: String
        var isFavourite: Bool
        
        var freeSpacesString: String {
            String(numberOfFreePlaces) + "/" + String(totalNumberOfPlaces)
        }
    }
    
    struct APIParkingPlace: Codable {
        let properties: Properties
    }
}

extension ParkingListView.APIParkingPlace {
    struct Properties: Codable {
        let id: Int
        let name: String
        let numberOfFreePlaces: Int
        let totalNumberOfPlaces: Int
        let parkingType: ParkingType
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case numberOfFreePlaces = "num_of_free_places"
            case totalNumberOfPlaces = "total_num_of_places"
            case parkingType = "parking_type"
        }
    }
    
    struct ParkingType: Codable {
        let description: String
    }
}

#Preview {
    ParkingListView(
        parkingPlaces: [
            .init(
                id: 1,
                name: "Holešovice",
                numberOfFreePlaces: 51,
                totalNumberOfPlaces: 200,
                parkingType: "P+R parkoviště",
                isFavourite: false
            ),
            .init(
                id: 1,
                name: "Holešovice",
                numberOfFreePlaces: 51,
                totalNumberOfPlaces: 200,
                parkingType: "P+R parkoviště",
                isFavourite: true
            )
        ]
    )
}

#Preview {
    ParkingListView(
        parkingPlaces: []
    )
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
                isFavourite: false
            ),
            onToggleFavorite: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
