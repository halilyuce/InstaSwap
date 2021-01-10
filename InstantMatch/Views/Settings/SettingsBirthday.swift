//
//  SettingsBirthday.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

struct SettingsBirthday: View {
    @Binding var user: User?
    @State var birthday: Date = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
    let max = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
    @State var error: Bool = false
    @ObservedObject var authVM : AuthVM = .shared
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Birthday")) {
                DatePicker(selection: $birthday, in: ...max, displayedComponents: .date) {
                    Text("Birthday:")
                        .foregroundColor(.gray)
                }
            }
            
            Button {
                self.authVM.updateUser(birthDate: self.birthday.toString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")) { success in
                    if success{
                        self.user?.birthDate = self.birthday.toString(format: "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")
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
            self.birthday = (user?.birthDate ?? "").toDateNodeTS()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .alert(isPresented: $error) {
            Alert(title: Text("An error occured!"), message: Text(authVM.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it")))
        }
    }
}

