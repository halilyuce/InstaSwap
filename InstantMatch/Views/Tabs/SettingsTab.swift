//
//  SettingsTab.swift
//  InstantMatch
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import StoreKit

struct SettingsTab: View {
    
    @State var selection: Int? = nil
    @State var notify = true
    @State var beSure: Bool = false
    @ObservedObject var authVM: AuthVM = .shared
    
    var body: some View {
        NavigationView{
            List{
                Section(header: HStack{
                    Image(systemName: "person.circle")
                        .foregroundColor(.accentColor)
                    Text("Profile Settings")
                    
                }) {
                    NavigationLink(destination:SettingsName(user: $authVM.user), tag: 0, selection: $selection){
                        HStack{
                            Text("Name")
                            Spacer()
                            Text(authVM.user?.name ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:SettingsInstagram(user: $authVM.user), tag: 1, selection: $selection){
                        HStack{
                            Text("Instagram")
                            Spacer()
                            Text("@\(authVM.user?.username ?? "")")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:SettingsBirthday(user: $authVM.user), tag: 2, selection: $selection){
                        HStack{
                            Text("Birthday")
                            Spacer()
                            Text(authVM.user?.birthDate?.toDateNodeTS().toString() ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:SettingsGender(user: $authVM.user), tag: 3, selection: $selection){
                        HStack{
                            Text("Gender")
                            Spacer()
                            Text(authVM.user?.gender == 0 ? "Male".localized : authVM.user?.gender == 1 ? "Female".localized : "Other".localized)
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:SettingsLookingFor(user: $authVM.user), tag: 4, selection: $selection){
                        HStack{
                            Text("Looking for")
                            Spacer()
                            Text(authVM.user?.lookingFor == 0 ? "Male".localized : authVM.user?.lookingFor == 1 ? "Female".localized : "Both".localized)
                                .foregroundColor(.gray)
                        }
                    }
                    if #available(iOS 14.0, *) {
                        NavigationLink(destination:PhotosViewNew(user: $authVM.user), tag: 5, selection: $selection){
                            HStack{
                                Text("Edit Photos")
                                Spacer()
                                Text("\(authVM.user?.images?.count ?? 0) \(authVM.user?.images?.count ?? 0 > 1 ? "Photos".localized : "Photo".localized)")
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        NavigationLink(destination:PhotosViewOld(user: $authVM.user).navigationBarBackButtonHidden(true), tag: 5, selection: $selection){
                            HStack{
                                Text("Edit Photos")
                                Spacer()
                                Text("\(authVM.user?.images?.count ?? 0) \(authVM.user?.images?.count ?? 0 > 1 ? "Photos".localized : "Photo".localized)")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                Section(header: HStack{
                    Image(systemName: "rectangle.stack.person.crop")
                        .foregroundColor(.accentColor)
                    Text("About InstantMatch")
                }, footer: Text("InstantMatch is made by Labters Inc. - United Kingdom")) {
                    Toggle(isOn: $notify) {
                        Text("Notifications")
                    }
                    HStack{
                        Text("Rate InstantMatch")
                        Spacer()
                    }.onTapGesture {
                        if #available(iOS 14.0, *) {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }else{
                            SKStoreReviewController.requestReview()
                        }
                    }
                    NavigationLink(destination:SafariView(url: URL(string:"https://api.labters.com/terms-of-service")!).navigationBarTitle(Text("Terms of Service"), displayMode: .inline), tag: 6, selection: $selection){
                        Text("Terms of Service")
                    }
                    NavigationLink(destination:SafariView(url: URL(string:"https://api.labters.com/privacy-notice")!).navigationBarTitle(Text("Privacy Policy"), displayMode: .inline), tag: 7, selection: $selection){
                        Text("Privacy Policy")
                    }
                }
                Section(header: HStack{
                    Image(systemName: "power")
                        .foregroundColor(.accentColor)
                    Text("Account Actions")
                }) {
                    HStack{
                        Button(action:{
                            self.authVM.logOut()
                        }){
                            Text("Logout")
                        }
                        Spacer()
                    }
                    HStack{
                        Button(action:{
                            self.beSure.toggle()
                        }){
                            Text("Delete Account")
                        }
                        Spacer()
                    }
                }
            }.modifier(GroupedListModifier())
            .navigationBarTitle(Text("Settings"))
        }.phoneOnlyStackNavigationView()
        .alert(isPresented: $beSure) {
            Alert(title: Text("Delete Account"), message: Text("You are about to delete your account, are you sure you want to do this?"), primaryButton: Alert.Button.default(
                    Text("Cancel")), secondaryButton: Alert.Button.destructive(Text("Yes, sure"), action: {
                        authVM.deleteUser() { success in
                            if success{
                                self.authVM.logOut()
                            }
                        }
                    }))
        }
    }
}

struct SettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
            .preferredColorScheme(.dark)
    }
}
