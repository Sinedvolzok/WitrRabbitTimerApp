//
//  WRTimer+Model.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//
import SwiftUI
import Foundation
import SwiftData

@Model
final class WRTimer: Setupable {
    @Attribute(.unique)
    var id: UUID = UUID()
    
    @Relationship(deleteRule: .cascade)
    var state: State
    var settings: Settings
    
    init(state: State = .init(isRunning: false, elapsed: 0),
         settings: Settings) {
        self.state = state
        self.settings = settings
    }
    
    static var defaultValue: WRTimer {
        WRTimer(
            state: State(isRunning: false, elapsed: 0),
            settings: Settings(
                title: "Default",
                icon: .stopwatch,
                colorScheme: .blueGray,
                phase: Settings.Phase(
                    duration: 60,
                    style: .countdown
                )
            )
        )
    }
}

// MARK: - WRTimer.State
extension WRTimer {
    @Model
    final class State {
        var id: UUID = UUID()
        var isRunning: Bool
        var elapsed: Double
        var disappearTime: Date?
        var currentSettingsIteration: Int = 0
        
        init(isRunning: Bool, elapsed: Double) {
            self.isRunning = isRunning
            self.elapsed = elapsed
        }
        
        internal func calculateElapsedTimeOnRunning() {
            if let disappearTime {
                let elapsedTimeInterval = Date().timeIntervalSince(disappearTime)
                elapsed += elapsedTimeInterval
            }
            disappearTime = nil
        }
        
        internal func rememberTimeOnRunning() {
            if isRunning { disappearTime = .now }
        }
    }
}
