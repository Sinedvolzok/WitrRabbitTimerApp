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
    var currentStateImageName: String {
        settings.phases[state.currentSettingsIteration].style.iconName
    }
    var elapsedDescription: String {
        String(format: "%.0f", state.elapsed)
    }
    var currentDurationDescription: String {
        String(format: "%.0f", currentDuration)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WRSettingsView(settings: settings, currentActivePhase: 0)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial)
            )
            Gauge(value: state.elapsed, in: 0.0...currentDuration) {}
            currentValueLabel: {} minimumValueLabel: { Text("0") }
            maximumValueLabel: {
                Text("\(elapsedDescription) / \(currentDurationDescription)")
            }
            .foregroundStyle(.secondary)
            .gaugeStyle(.linearCapacity)
            .padding()

        }
    }
}

#Preview {
    let activeInterval = WRTimer(
        state: WRTimer.State(
            isRunning: true,
            elapsed: 4),
        settings: WRTimer.Settings(
            title: "Title",
            icon: .star,
            colorScheme: .orangeTeal,
            actionValue: 10.0,
            restValue: 5.0,
            longRestValue: 15.0,
            evryThIsLong: 3
            )
        )
    let activeSingle = WRTimer(
        state: WRTimer.State(
            isRunning: true,
            elapsed: 12),
        settings: WRTimer.Settings())
    List {
        NavigationLink {
            Text("Sample link single")
        } label: {
            WRActiveTimerCell(
                settings: activeInterval.settings,
                state: activeInterval.state
            )
        }
        NavigationLink {
            Text("Sample link interval")
        } label: {
            WRActiveTimerCell(
                settings: activeSingle.settings,
                state: activeSingle.state
            )
        }
    }
}
