//
//  ProfileView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("apiKey") var apiKey: String?
    var onLogout: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            contentView
                .padding(.horizontal)
                .toolbar {
                    Button {
                        logout()
                    } label: {
                        Text("Odhlásit se")
                            .frame(maxWidth: .infinity)
                    }
                }
                .navigationTitle("Profil")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            Text("API key:")
                .bold()
            
            Text(apiKey ?? "")
        }
    }
    
    // MARK: - Helpers
    
    func logout() {
        apiKey = nil
        UserDefaults.standard.setValue([], forKey: "places")
        onLogout()
    }
}

#Preview {
    ProfileView(onLogout: { })
}
