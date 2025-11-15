//
//  MainView.swift
//  Social Media
//
//  Created by TrungAnhx on 15/11/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // MARK: Tabview with recent post and profile tabs
        TabView {
            Text("Recent Post")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Post")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
}
