//
//  LoginView.swift
//  PragueOAPISwiftUI
//
//  Created by Rostislav Babáček on 02.03.2024.
//

import SwiftUI

struct LoginView: View {
    @State var text: String = ""
    
    var body: some View {
        NavigationStack {
            contentView
                .padding()
                .onAppear {
                    text = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjUxNywiaWF0IjoxNzA5MzkyODA2LCJleHAiOjExNzA5MzkyODA2LCJpc3MiOiJnb2xlbWlvIiwianRpIjoiN2VlOTY3NDktMjMzMS00NGU3LWEwNTktNzZkZWYyZDFhOTA1In0.5k-fwhUKhVmuDEV090nXWOHONK-I5cgjyV54tzL-FXs"
                }
                .navigationTitle("Přihlášení")
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            Text("API key:")
                .bold()
            TextEditor(text: $text)
                .multilineTextAlignment(.leading)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Spacer()
            
            Button {
                UserDefaults.standard.setValue(text, forKey: "apiKey")
            } label: {
                Text("Uložit")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    LoginView()
}
