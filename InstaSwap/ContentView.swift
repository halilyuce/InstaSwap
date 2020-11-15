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
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            RequestsTab()
                .tabItem {
                    Image(systemName: "person.badge.plus.fill")
                        .renderingMode(.template)
                }.tag(SelectedTab.requests)
            SwapsTab()
                .tabItem {
                    Image(systemName: "rectangle.stack.person.crop.fill")
                        .renderingMode(.template)
                }.tag(SelectedTab.swaps)
            SettingsTab()
                .tabItem {
                    Image(systemName: "gear")
                        .renderingMode(.template)
                }.tag(SelectedTab.settings)
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
