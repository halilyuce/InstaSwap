//
//  SettingsBirthday.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

struct SettingsBirthday: View {
    @Binding var user: User?
    @State var birthday: Date = Date()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Birthday")) {
                DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {
                    Text("Birthday:")
                        .foregroundColor(.gray)
                }
            }
            
            Button {
                self.user?.birthDate = self.birthday.toString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")
                try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }.listRowBackground(Color.pink)
        }
        .onAppear(){
            self.birthday = (user?.birthDate ?? "").toDateNodeTS()
        }
        .navigationBarTitle(Text("Birth Date"), displayMode: .inline)
    }
}

