//
//  ContentView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("apiKey") var apiKey: String?
    
    var body: some View {
        if (apiKey ?? "").isEmpty {
            LoginView()
        } else {
            tabView
        }
    }
    
    var tabView: some View {
        TabView {
            DistrictListView()
                .tabItem {
                    Label(
                        title: { Text("Městské části") },
                        icon: { Image(systemName: "house.and.flag") }
                    )
                }
            
            ParkingListView(viewModel: .init())
                .tabItem {
                    Label(
                        title: { Text("Parkování") },
                        icon: { Image(systemName: "parkingsign.radiowaves.left.and.right") }
                    )
                }
            
            ProfileView(
                onLogout: {
                    
                }
            )
            .tabItem {
                Label(
                    title: { Text("Profil") },
                    icon: { Image(systemName: "person") }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}

