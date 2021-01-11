//
//  ContentView.swift
//  InstantMatch
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

extension NSNotification {
    static let goNotification = NSNotification.Name.init("Notification")
}

enum SelectedTab: Hashable {
    case requests
    case swaps
    case settings
}

struct ContentView: View {
    
    @ObservedObject var authVM: AuthVM = .shared
    @ObservedObject var viewModel: ViewModel = .shared
    
    var body: some View {
        ZStack{
            if (authVM.token != "" && !authVM.showPhotoUpload) || authVM.loggedIn {
                TabView(selection: self.$authVM.selectedTab) {
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
                            Text("Match")
                        }.tag(SelectedTab.swaps)
                    SettingsTab()
                        .tabItem {
                            Image(systemName: "gear")
                                .renderingMode(.template)
                            Text("Settings")
                        }.tag(SelectedTab.settings)
                }
            }else{
                WelcomeView()
            }
        }.accentColor(Color(UIColor.systemPink))
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.goNotification))
        { obj in
            let userInfo = obj.userInfo
            if let tapped = userInfo?["tapped"] as? Bool{
                if tapped{
                    self.authVM.selectedTab = .requests
                }
            }
            if let model = userInfo?["model"] as? Notification{
                if self.viewModel.notifications.firstIndex(where: {$0.id == model.id }) == nil{
                    self.viewModel.notifications.insert(model, at: 0)
                }
            }
        }
    }
}
