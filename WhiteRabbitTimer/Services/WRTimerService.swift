//
//  WRTimerService.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//

import Foundation
import Combine

@MainActor
@Observable
final class WRTimerService: Sendable {
    
    var timerHandler: Cancellable? = nil
    var timer = Timer.publish(every: 1, on: .main, in: .default)
    
    var instance: WRTimer = .defaultValue
    
    var currentSettings: WRTimer.Settings.Phase {
        instance.settings.phases[instance.state.currentSettingsIteration]
    }
    
    private func startTimer() {
        instance.state.status = WRTimer.Status.started.rawValue
        timer = Timer.publish(every: 1, on: .main, in: .default)
        timerHandler = timer.connect()
    }
    
    private func stopTimer() {
        timerHandler?.cancel()
        timerHandler = nil
    }
    
    func setup(for instance: WRTimer) {
        self.instance = instance
        if instance.state.status != WRTimer.Status.stopped.rawValue {
            startTimer()
        }
    }
    
    func start() {
        startTimer()
    }
    
    func pause() {
        stopTimer()
    }
    
    func stop() {
        stopTimer()
        instance.state.status = WRTimer.Status.stopped.rawValue
        instance.state.disappearTime = nil
        instance.state.elapsed = 0
        instance.state.currentSettingsIteration = 0
    }
    
    func run() {
        if instance.state.elapsed < currentSettings.duration,
           instance.state.status != WRTimer.Status.stopped.rawValue
        {
            instance.state.elapsed += currentSettings.interval
        } else {
            stopTimer()
            instance.state.disappearTime = nil
            instance.state.elapsed = 0
        }
    }
    
    func nextIteration() {
        instance.state.currentSettingsIteration += 1
        let phasesCount = instance.settings.phases.count
        let currentIteration = instance.state.currentSettingsIteration
        instance.state.currentSettingsIteration = currentIteration % phasesCount
    }
}
