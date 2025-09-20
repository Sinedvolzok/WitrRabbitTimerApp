//
//  WhiteRabbitTimerApp.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 02.09.2025.
//

import SwiftUI
import SwiftData

@main
struct WhiteRabbitTimerApp: App {
    
    var body: some Scene {
        WindowGroup {
            WRTabbarView()
        }
        .modelContainer(for: [
            WRTimer.self,
            WRTemplate.self,
            WRAnalyticsItem.self,
            WRTimer.State.self,
            WRTag.self
        ])
    }
}
