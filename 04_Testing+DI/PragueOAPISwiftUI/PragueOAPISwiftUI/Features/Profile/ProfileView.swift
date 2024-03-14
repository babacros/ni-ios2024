//
//  ProfileView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModeling
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .padding(.horizontal)
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            Text("API key:")
                .bold()
            
            Text(viewModel.apiKey ?? "")
        }
    }
}
//
//#Preview {
//    ProfileView(onLogout: { })
//}
