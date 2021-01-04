//
//  SettingsGender.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

struct SettingsGender: View {
    @Binding var user: User?
    @State var gender: Int = 0
    @ObservedObject var authVM: AuthVM = .shared
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Your Gender")) {
                HStack{
                    Text("Gender:")
                        .foregroundColor(.gray)
                        .frame(width:90, alignment: .leading)
                    Spacer()
                    Picker(selection: $gender, label: Text("Gender:")) {
                        ForEach(0 ..< self.authVM.genders.count) {
                            Text(self.authVM.genders[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            Button {
                self.user?.gender = self.gender
                try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }.listRowBackground(Color.pink)
        }
        .onAppear(){
            self.gender = user?.gender ?? 0
        }
        .navigationBarTitle(Text("Your Gender"), displayMode: .inline)
    }
}
