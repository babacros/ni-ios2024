//
//  LoginView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel
    
    // MARK: - Body
    
    var body: some View {
        contentView
            .padding()
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            Text("API key:")
                .bold()
            TextEditor(text: $viewModel.text)
                .multilineTextAlignment(.leading)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Spacer()
            
            Button {
                viewModel.onSave()
            } label: {
                Text("Uložit")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
