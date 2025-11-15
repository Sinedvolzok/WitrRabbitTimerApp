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
    @State private var timerState: WRTimer.Status = .stopped
    @State private var isShowingSettings: Bool = false
    private var pending: Double {
        timer.settings.phases[timer.state.currentSettingsIteration].duration
        - timer.state.elapsed
    }
    private var phaseStyle: WRTimer.Settings.Phase.Style {
        timer.settings.phases[timer.state.currentSettingsIteration].style
    }
    
    private var currentPhaseDuration: Double {
        timer.settings.phases[timer.state.currentSettingsIteration].duration
    }
    private var formattedPending: String {
        let duration = Duration.seconds(pending)
        let formatted = duration.formatted(.time(pattern: .minuteSecond))
        return formatted
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
                Spacer()
                Text(formattedPending).font(.largeTitle)
                WRCircularIndicatorView(pending: pending, duration: currentPhaseDuration)
                    .padding(40)
                ControlButtonsView(
                    timerState: $timerState,
                    isShowingSettings: $isShowingSettings
                )
            }
            .onAppear {
                service.setup(for: timer)
            }
            .onReceive(service.timer) { _ in
                service.run()
            }
            .onChange(of: timerState) { _, _ in
                switch timerState {
                case .stopped:
                    service.stop()
                case .started:
                    service.start()
                case .paused:
                    service.pause()
                }
            }
            .onChange(of: timer.state.elapsed) { _, _ in
                if timer.state.elapsed == 0 {
                    print(timer.state.currentSettingsIteration)
                    timerState = .paused
                    service.nextIteration()
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
                        .init(duration: 2*6, style: .action),
                        .init(duration: 1*6, style: .rest),
                        .init(duration: 2*6, style: .action),
                        .init(duration: 1*6, style: .rest),
                        .init(duration: 2*6, style: .action),
                        .init(duration: 3*6, style: .longRest)
                    ]
        )
    )
    WRTimerView(timer: timer)
        .safeAreaPadding(20)
}
