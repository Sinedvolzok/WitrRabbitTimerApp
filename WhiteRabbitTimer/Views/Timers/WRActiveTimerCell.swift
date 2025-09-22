//
//  WRActiveTimerCell.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 22.09.2025.
//

import SwiftUI

struct WRActiveTimerCell: View {
    var settings: WRTimer.Settings
    var state: WRTimer.State
    var currentDuration: Double {
        settings.phases[state.currentSettingsIteration].duration
    }
    var body: some View {
        HStack {
            WRSettingsView(settings: settings)
            Spacer()
            Gauge(value: state.elapsed, in: 0.0...currentDuration) {
                Text(String(format: "%.0f", state.elapsed))
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .padding()

        }
    }
}

#Preview {
    let analyticsItem = WRAnalyticsItem(
        settings: WRTimer.Settings(),
        startDate: Date(),
        tags: [WRTag(title: "RB", color: .pink, iconName: "rainbow")])
    let activeTimer = WRTimer(
        state: WRTimer.State(
            isRunning: true,
            elapsed: 12),
        settings: WRTimer.Settings())
    List {
        NavigationLink {
            Text("Sample link")
        } label: {
            WRActiveTimerCell(
                settings: analyticsItem.settings,
                state: activeTimer.state
            )
        }
    }
}
