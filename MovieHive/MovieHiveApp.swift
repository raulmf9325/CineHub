//
//  CineHubApp.swift
//  CineHub
//
//  Created by Raul Mena on 5/6/24.
//

import SwiftUI

@main
struct CineHubApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(model: .init(apiClient: .live))
        }
    }
}
