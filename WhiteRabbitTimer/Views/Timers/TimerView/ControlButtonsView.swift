//
//  ControlButtonsView.swift
//  TestTimer
//
//  Created by Denis Kozlov on 08.07.2025.
//
import SwiftUI

enum TimerState {
    case stopped
    case started
    case paused
}

struct ControlButtonsView: View {
    @Binding var timerState: WRTimer.Status
    @Binding var isShowingSettings: Bool
    var isPaused: Bool { timerState != .started }
    var body: some View {
//        DStack(spacing: 24, isOpposite: true) {
        HStack(spacing: 24) {
            Group {
                Button {
                    timerState = .stopped
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .fontWeight(.semibold)
                        .padding(16)
                }
                .disabled(timerState == .stopped)
                Button {
                    switch timerState {
                    case .stopped, .paused:
                        timerState = .started
                    case .started:
                        timerState = .paused
                    }
                } label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.system(size: 36.0))
                        .padding(24)
                        .frame(width: 80)
                }
                .contentTransition(.symbolEffect(.replace))
                Button {
                    isShowingSettings = true
                } label: {
                    Image(systemName: "slider.horizontal.below.rectangle")
                        .fontWeight(.semibold)
                        .padding(16)
                }
                .disabled(timerState != .stopped)
            }
            .optionalGlassEffect()
        }
    }
}

#Preview {
    @Previewable @State var timerState: WRTimer.Status = .stopped
    @Previewable @State var isShowingSettings: Bool = false
    ZStack {
        Image("patternTest").resizable(
        capInsets: EdgeInsets(
            top: 23,
            leading: 23,
            bottom: 23,
            trailing: 23),
        resizingMode: .tile
        )
        .ignoresSafeArea()
        ControlButtonsView(
            timerState: $timerState,
            isShowingSettings: $isShowingSettings
        )
    }
}
