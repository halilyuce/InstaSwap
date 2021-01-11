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
    @State var error: Bool = false
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
                self.authVM.updateUser(lookingFor: lookingFor) { success in
                    if success{
                        self.user?.lookingFor = self.lookingFor
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
            self.lookingFor = user?.lookingFor ?? 0
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .alert(isPresented: $error) {
            Alert(title: Text("An error occured!"), message: Text(authVM.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it")))
        }
    }
}
