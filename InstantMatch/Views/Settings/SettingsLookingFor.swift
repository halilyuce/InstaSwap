//
//  SettingsLookingFor.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

struct SettingsLookingFor: View {
    @Binding var user: User?
    @State var lookingFor: Int = 0
    @ObservedObject var authVM: AuthVM = .shared
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("What Do You Looking For?")) {
                HStack{
                    Text("Looking For:")
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.gray)
                        .frame(width:100, alignment: .leading)
                    Spacer()
                    Picker(selection: $lookingFor, label: Text("Looking For:")) {
                        ForEach(0 ..< self.authVM.lookingfor.count) {
                            Text(self.authVM.lookingfor[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            Button {
                self.user?.lookingFor = self.lookingFor
                try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }.listRowBackground(Color.pink)
        }
        .onAppear(){
            self.lookingFor = user?.lookingFor ?? 0
        }
        .navigationBarTitle(Text("Looking For"), displayMode: .inline)
    }
}
