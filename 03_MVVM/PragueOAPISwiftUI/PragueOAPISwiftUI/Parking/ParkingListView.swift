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
    @State var favouritePlaces: [Int] = []
    @State var selectedAddress: IdentifiablePlace?
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
                .sheet(item: $selectedAddress) {
                    AddressMapView(place: $0) {
                        selectedAddress = nil
                    }
                }
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
                    ParkingCell(
                        place: place,
                        isFavourite: favouritePlaces.contains(place.id),
                        onToggleFavorite: { toggleFavorites(for: place) },
                        onAddressTapped: { selectedAddress = $0 }
                    )
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
                + url.absoluteString
            )
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            
            print(
                "⬇️ "
                + "[\(httpResponse?.statusCode ?? -1)]: " + url.absoluteString //+ "\n"
//                + String(data: data, encoding: .utf8)!
            )
            
            let features = try? JSONDecoder().decode(Features<APIParkingPlace>.self, from: data)
            print("[Received Data]: \(features?.features.map { $0.properties.name } ?? [])")
            self.parkingPlaces = features?.features.compactMap {
                let properties = $0.properties
                let coordinatesTupple = $0.geometry.coordinatesTupple
                return ParkingPlace(
                    id: properties.id,
                    name: properties.name,
                    numberOfFreePlaces: properties.numberOfFreePlaces,
                    totalNumberOfPlaces: properties.totalNumberOfPlaces,
                    parkingType: properties.parkingType.description,
                    address: properties.address,
                    location: .init(
                        name: properties.name,
                        lat: coordinatesTupple.lat,
                        lon: coordinatesTupple.lon
                    )
                )
            } ?? []
            setVisiblePlaces()
        }
    }
    
    func setVisiblePlaces() {
        let favouritePlaces = UserDefaults.standard.value(forKey: "places") as? [Int] ?? []
        self.favouritePlaces = favouritePlaces
        
        switch selectedMode {
        case .all:
            presentedParkingPlaces = parkingPlaces
        case .favourite:
            presentedParkingPlaces = parkingPlaces.filter({ favouritePlaces.contains($0.id) })
        }
    }
    
    func toggleFavorites(for place: ParkingPlace) {
        var places = UserDefaults.standard.value(forKey: "places") as? [Int] ?? []
        if places.contains(where: { $0 == place.id }) {
            places.removeAll { $0 == place.id }
        } else {
            places.append(place.id)
        }
        UserDefaults.standard.setValue(places, forKey: "places")
        setVisiblePlaces()
    }
}

extension ParkingListView {
    struct ParkingCell: View {
        var place: ParkingPlace
        var onToggleFavorite: () -> Void
        var onAddressTapped: (IdentifiablePlace) -> Void
        var isFavourite = false
        
        init(
            place: ParkingPlace,
            isFavourite: Bool,
            onToggleFavorite: @escaping (() -> Void),
            onAddressTapped: @escaping (IdentifiablePlace) -> Void
        ) {
            self.place = place
            self.isFavourite = isFavourite
            self.onToggleFavorite = onToggleFavorite
            self.onAddressTapped = onAddressTapped
        }
        
        // MARK: - Views
        
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
                    onToggleFavorite()
                } label: {
                    let iconName = isFavourite ? "star.fill" : "star"
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

extension ParkingListView {
    struct ParkingPlace: Identifiable, Hashable {
        let id: Int
        let name: String
        let numberOfFreePlaces: Int
        let totalNumberOfPlaces: Int
        let parkingType: String
        let address: Address
        let location: IdentifiablePlace?
        
        var freeSpacesString: String {
            String(numberOfFreePlaces) + "/" + String(totalNumberOfPlaces)
        }
    }
    
    struct APIParkingPlace: Decodable {
        let properties: Properties
        let geometry: Geometry
    }
}

extension ParkingListView.APIParkingPlace {
    struct Properties: Decodable {
        let id: Int
        let name: String
        let numberOfFreePlaces: Int
        let totalNumberOfPlaces: Int
        let parkingType: ParkingType
        let address: Address
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case numberOfFreePlaces = "num_of_free_places"
            case totalNumberOfPlaces = "total_num_of_places"
            case parkingType = "parking_type"
            case address
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
                address: .init(addressFormatted: "FIT"),
                location: nil
            ),
            .init(
                id: 1,
                name: "Holešovice",
                numberOfFreePlaces: 51,
                totalNumberOfPlaces: 200,
                parkingType: "P+R parkoviště",
                address: .init(addressFormatted: "FIT"),
                location: nil
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
                address: .init(addressFormatted: "FIT"),
                location: nil
            ),
            isFavourite: false,
            onToggleFavorite: {},
            onAddressTapped: { _ in }
        )
        .previewLayout(.sizeThatFits)
    }
}
