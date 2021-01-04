//
//  SettingsInstagram.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

struct SettingsInstagram: View {
    @Binding var user: User?
    @State var username: String = ""
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Instagram Username")) {
                TextField("Username", text: $username)
            }
            
            Button {
                self.user?.username = self.username
                try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }.listRowBackground(Color.pink)
        }
        .onAppear(){
            self.username = user?.username ?? ""
        }
        .navigationBarTitle(Text("Instagram Username"), displayMode: .inline)
    }
}

