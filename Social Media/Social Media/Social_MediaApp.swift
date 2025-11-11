//
//  Social_MediaApp.swift
//  Social Media
//
//  Created by TrungAnhx on 8/11/25.
//

import SwiftUI
import Firebase

@main
struct Social_MediaApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
