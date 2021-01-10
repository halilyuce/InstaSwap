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
    @State var error: Bool = false
    @ObservedObject var authVM : AuthVM = .shared
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Instagram Username")) {
                TextField("Username", text: $username)
            }
            
            Button {
                self.authVM.updateUser(username: username) { success in
                    if success{
                        self.user?.username = self.username
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
        }
        .onAppear(){
            self.username = user?.username ?? ""
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .alert(isPresented: $error) {
            Alert(title: Text("An error occured!"), message: Text(authVM.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it")))
        }
    }
}

