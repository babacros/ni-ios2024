//
//  ProfileView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            contentView
                .padding(.horizontal)
                .toolbar {
                    Button {
                        viewModel.logout()
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
            
            Text(viewModel.apiKey ?? "")
        }
    }
    
    // MARK: - Helpers
    

}
//
//#Preview {
//    ProfileView(onLogout: { })
//}
