//
//  WRTimer+Settings.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//
import SwiftUI
import Foundation

extension WRTimer {
    struct Settings: Identifiable, Codable {
        var id: UUID = .init()
        let title: String
        let icon: Icon
        let colorScheme: ColorScheme
        let phases: [Phase]
        var repeats: Bool = false
        
        // MARK: init for countdown timer settings
        init(title: String, icon: Icon, colorScheme: ColorScheme, phases: [Phase]) {
            self.title = title
            self.icon = icon
            self.colorScheme = colorScheme
            self.phases = phases
        }
        
        init(title: String, icon: Icon, colorScheme: ColorScheme, phase: Phase) {
            self.title = title
            self.icon = icon
            self.colorScheme = colorScheme
            self.phases = [phase]
        }
        
        init() {
            self.init(
                title: "Default",
                icon: .bird,
                colorScheme: .greenRed,
                phase: Phase(duration: 20, style: .countdown)
            )
        }
        
        // MARK: init for interval timer settings without long rest
        init(title: String, icon: Icon, colorScheme: ColorScheme,
             actionValue: Double, restValue: Double
        ) {
            let phases: [WRTimer.Settings.Phase] = [
                .init(duration: actionValue, style: .action),
                .init(duration: restValue, style: .rest),
                .init(duration: actionValue, style: .action),
                .init(duration: restValue, style: .rest)
            ]
            self.init(title: title, icon: icon, colorScheme: colorScheme, phases: phases)
        }
        
        // MARK: init for interval timer settings with long rest
        init(title: String, icon: Icon, colorScheme: ColorScheme,
             actionValue: Double, restValue: Double,
             longRestValue: Double, evryThIsLong: Int
        ) {
            let normalInterval: [WRTimer.Settings.Phase] = [
                .init(duration: actionValue, style: .action),
                .init(duration: restValue, style: .rest)
            ]
            let longInterval: [WRTimer.Settings.Phase] = [
                .init(duration: actionValue, style: .action),
                .init(duration: longRestValue, style: .rest)
            ]
            var phases: [WRTimer.Settings.Phase] = []
            for _ in 1..<evryThIsLong {
                phases.append(contentsOf: normalInterval)
            }
            phases.append(contentsOf: longInterval)
            self.init(title: title, icon: icon, colorScheme: colorScheme, phases: phases)
        }
        
        struct Phase: Identifiable, Codable {
            var id: UUID = UUID()
            let duration: Double
            let style: Style
            var interval: Double = 1
            
            enum Style: String, Codable {
                case countdown
                case rest
                case action
                case stopwatch
            }
        }
    }
}
