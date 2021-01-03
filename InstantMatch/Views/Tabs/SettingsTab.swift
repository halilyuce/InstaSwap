//
//  SettingsTab.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import StoreKit

struct SettingsTab: View {

    @State var user: User? = try? UserDefaults.standard.customObject(forKey: "user")
    @State var selection: Int? = nil
    @State private var notify = true
    @ObservedObject var authVM: AuthVM = .shared
    
    var body: some View {
        NavigationView{
            List{
                Section(header: HStack{
                    Image(systemName: "person.circle")
                        .foregroundColor(.accentColor)
                    Text("Profile Settings")
                    
                }) {
                    NavigationLink(destination:Text("Name: Halil Yüce"), tag: 0, selection: $selection){
                        HStack{
                            Text("Name")
                            Spacer()
                            Text(user?.name ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:Text("Gender: Male"), tag: 1, selection: $selection){
                        HStack{
                            Text("Gender")
                            Spacer()
                            Text(user?.gender == 0 ? "Male" : user?.gender == 1 ? "Female" : "Other")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:Text("Country: Turkey"), tag: 2, selection: $selection){
                        HStack{
                            Text("Country")
                            Spacer()
                            Text("Turkey")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:Text("Birthday: 18.06.1993"), tag: 3, selection: $selection){
                        HStack{
                            Text("Birthday")
                            Spacer()
                            Text(user?.birthDate?.toDateNodeTS().toString() ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:Text("Looking for: Female - Worldwide"), tag: 4, selection: $selection){
                        HStack{
                            Text("Looking for")
                            Spacer()
                            Text("Female - Worldwide")
                                .foregroundColor(.gray)
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
                    NavigationLink(destination:SafariView(url: URL(string:"https://labters.com/gasomeapp")!).navigationBarTitle(Text("Terms of Service"), displayMode: .inline), tag: 5, selection: $selection){
                        Text("Terms of Service")
                    }
                    NavigationLink(destination:SafariView(url: URL(string:"https://labters.com/gasomeapp")!).navigationBarTitle(Text("Privacy Policy"), displayMode: .inline), tag: 6, selection: $selection){
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
                        Button(action:{}){
                            Text("Delete Account")
                        }
                        Spacer()
                    }
                }
            }.modifier(GroupedListModifier())
            .navigationBarTitle(Text("Settings"))
        }.phoneOnlyStackNavigationView()
    }
}

struct SettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTab()
            .preferredColorScheme(.dark)
    }
}
