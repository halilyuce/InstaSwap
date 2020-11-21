//
//  SettingsTab.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import StoreKit

struct SettingsTab: View {
    
    @State var selection: Int? = nil
    @State private var notify = true
    
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
                            Text("Halil Yüce")
                                .foregroundColor(.gray)
                        }
                    }
                    NavigationLink(destination:Text("Gender: Male"), tag: 1, selection: $selection){
                        HStack{
                            Text("Gender")
                            Spacer()
                            Text("Male")
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
                            Text("18 May 1993")
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
                    Text("About InstaMatch")
                }, footer: Text("InstaMatch is made by Labters Inc. - United Kingdom")) {
                    Toggle(isOn: $notify) {
                        Text("Notifications")
                    }
                    HStack{
                        Text("Rate InstaMatch")
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
                        Button(action:{}){
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
