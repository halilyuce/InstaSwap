//
//  SettingsName.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

struct SettingsName: View {
    
    @Binding var user: User?
    @State var name: String = ""
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Your Name")) {
                TextField("Full Name", text: $name)
            }
            
            Button {
                self.user?.name = self.name
                try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }.listRowBackground(Color.pink)
        }
        .onAppear(){
            self.name = user?.name ?? ""
        }
        .navigationBarTitle(Text("Your Name"), displayMode: .inline)
    }
}
