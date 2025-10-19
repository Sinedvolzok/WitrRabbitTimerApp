//
//  WRTimerView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 07.10.2025.
//

import SwiftUI

struct WRTimerView: View {
    var timer: WRTimer
    @State private var service = WRTimerService()
    @State private var timerState: TimerState = .stopped
    @State private var isShowingSettings: Bool = false
    private var pending: Double {
        timer.settings
            .phases[timer.state.currentSettingsIteration].duration - timer.state.elapsed
    }
    private var phaseStyle: WRTimer.Settings.Phase.Style {
        timer.settings.phases[timer.state.currentSettingsIteration].style
    }
    var body: some View {
        
        ZStack {
            Group {
                switch phaseStyle {
                case .action:
                    Color.yellow
                case .rest:
                    Color.cyan
                case .longRest:
                    Color.teal
                case .countdown:
                    Color.green
                case .stopwatch:
                    Color.blue
                }
            }
            .ignoresSafeArea()
            VStack(alignment: .center, spacing: 100) {
                Gauge(
                    value: pending,
                    in: 0.0...timer.settings.phases[timer.state.currentSettingsIteration].duration
                ) {
                    Text("hello")
                } currentValueLabel: {
                    Text(String(format: "%.0f", pending))
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text(String(format: "%.0f", timer.settings.phases[timer.state.currentSettingsIteration].duration))
                }
                .gaugeStyle(.accessoryCircularCapacity)
                ControlButtonsView(
                    timerState: $timerState,
                    isShowingSettings: $isShowingSettings
                )
            }
            .onAppear {
                service.setup(for: timer)
            }
            .onReceive(service.timer) { timer in
                service.run()
            }
            .onChange(of: timerState) { _,_ in
                switch timerState {
                case .stopped:
                    service.stop()
                case .started:
                    service.start()
                case .paused:
                    service.pause()
                }
            }
        }
    }
}

#Preview {
    let timer: WRTimer = WRTimer(
        settings:
                .init(
                    title: "Default",
                    icon: .book,
                    colorScheme: .greenRed,
                    phases: [
                        .init(duration: 20, style: .action),
                        .init(duration: 10, style: .rest),
                        .init(duration: 20, style: .action),
                        .init(duration: 10, style: .rest),
                        .init(duration: 20, style: .action),
                        .init(duration: 15, style: .longRest)
                    ]
        )
    )
    WRTimerView(timer: timer)
        .safeAreaPadding(20)
}
