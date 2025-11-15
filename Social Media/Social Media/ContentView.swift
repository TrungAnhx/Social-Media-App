//
//  ContentView.swift
//  Social Media
//
//  Created by TrungAnhx on 8/11/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        // MARK: Redirecting user based on log status
        if logStatus {
            MainView()
        } else {
            LoginView()
        }
        
    }
}

#Preview {
    ContentView()
}
