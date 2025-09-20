//
//  WRSettingsView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 04.09.2025.
//

import SwiftUI

struct WRSettingsView: View {
    var settings: WRTimer.Settings
    private var maxRestValue: Double {
        let durations = settings.phases
            .filter({ $0.style == .rest })
            .map(\.duration)
        guard !durations.isEmpty, let last = durations.last else { return 0 }
        return max(durations[1], last)
    }
    private var maxDuration: Double {
        settings.phases.map(\.duration).max() ?? 0
    }
    private var actionValue: Double {
        settings.phases[0].duration
    }
    private var restValue: Double {
        settings.phases[1].duration
    }
    enum TimerViewStyle {
        case interval
        case single
        case stopwatch
    }
    
    var timerStyle: TimerViewStyle {
        if settings.phases.count > 1 {
            return .interval
        } else {
            if settings.phases[0].duration > 0 {
                return .single
            } else {
                return .stopwatch
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WRLabel(template: settings)
            switch timerStyle {
            case .interval:
                HStack(spacing: 8) {
                    Image(systemName: "timer")
                        .padding(.trailing, 4)
                    WRIntervalPhaseLabel(
                        value: actionValue,
                        imageName: "flame"
                    )
                    WRIntervalPhaseLabel(
                        value: restValue,
                        imageName: "water.waves"
                    )
                    if maxRestValue != settings.phases[1].duration {
                        WRIntervalPhaseLabel(
                            value: maxRestValue,
                            imageName: "water.waves.and.arrow.trianglehead.down"
                        )
                    }
                }
                .foregroundStyle(.secondary)
            case .single:
                HStack {
                    Image(systemName: "gauge.with.needle")
                        .padding(.trailing, 8)
                    Text(String(format: "%.0f", settings.phases[0].duration))
                }
                .foregroundStyle(.secondary)
            case .stopwatch:
                HStack {
                    Image(systemName: "stopwatch")
                        .padding(.trailing, 8)
                    Text("00:00,00")
                }
                .foregroundStyle(.secondary)
            }
        }
        .foregroundStyle(.foreground)
        .padding(.leading, 8)
    }
}

#Preview {
    let templateStopWatch =
    WRTimer.Settings(
        title: "Eggs",
        icon: .mountain,
        colorScheme: .purpleYellow,
        phase: .init(duration: 60, style: .countdown)
    )
    let templateInterval =
    WRTimer.Settings(
        title: "Task",
        icon: .bird,
        colorScheme: .tealMint,
        phases: [
            .init(duration: 20, style: .action),
            .init(duration: 5, style: .rest),
            .init(duration: 20, style: .action),
            .init(duration: 5, style: .rest),
        ]
    )
    let templateIntervalWithLongRest =
    WRTimer.Settings(
        title: "Progect",
        icon: .book,
        colorScheme: .indigoOrange,
        phases: [
            .init(duration: 20, style: .action),
            .init(duration: 5, style: .rest),
            .init(duration: 20, style: .action),
            .init(duration: 5, style: .rest),
            .init(duration: 20, style: .action),
            .init(duration: 15, style: .rest),
        ]
    )
    NavigationStack {
        List {
            WRSettingsView(settings: templateStopWatch)
            WRSettingsView(settings: templateInterval)
            WRSettingsView(settings: templateIntervalWithLongRest)
        }
    }
}

