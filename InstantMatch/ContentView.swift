//
//  ContentView.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

enum SelectedTab: Hashable {
    case requests
    case swaps
    case settings
}

struct ContentView: View {
    
    @State var selectedTab: SelectedTab = .swaps
    @ObservedObject var authVM: AuthVM = .shared
    @State var token = UserDefaults.standard.object(forKey: "token") as? String ?? ""
    
    var body: some View {
        ZStack{
            if token != "" || authVM.loggedIn {
                TabView(selection: self.$selectedTab) {
                    RequestsTab()
                        .tabItem {
                            Image(systemName: "person.badge.plus.fill")
                                .renderingMode(.template)
                            Text("Requests")
                        }.tag(SelectedTab.requests)
                    SwapsTab()
                        .tabItem {
                            Image(systemName: "rectangle.stack.person.crop.fill")
                                .renderingMode(.template)
                            Text("Swipes")
                        }.tag(SelectedTab.swaps)
                    SettingsTab()
                        .tabItem {
                            Image(systemName: "gear")
                                .renderingMode(.template)
                            Text("Settings")
                        }.tag(SelectedTab.settings)
                }
            }else{
                WelcomeView(sign: self.$authVM.loggedIn)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}
