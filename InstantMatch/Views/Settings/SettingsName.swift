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
    @State var error: Bool = false
    @ObservedObject var authVM : AuthVM = .shared
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $name)
            }
            
            Button {
                self.authVM.updateUser(name: name) { success in
                    if success{
                        self.user?.name = self.name
                        try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                        self.presentationMode.wrappedValue.dismiss()
                    }else{
                        self.error.toggle()
                    }
                }
            } label: {
                if self.authVM.updateStatus == .loading{
                    ActivityIndicatorView(isAnimating: .constant(true), style: .medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }else{
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }.listRowBackground(Color.pink)
        }.modifier(GroupedListModifier())
        .onAppear(){
            self.name = user?.name ?? ""
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .alert(isPresented: $error) {
            Alert(title: Text("An error occured!"), message: Text(authVM.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it")))
        }
    }
}
