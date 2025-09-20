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
    
    var instance: WRTimer = WRTimer.defaultValue
    
    var currentSettings: WRTimer.Settings.Phase {
        instance.settings.phases[instance.state.currentSettingsIteration]
    }
    
    internal func setup(for instance: WRTimer) {
        self.instance = instance
        if instance.state.isRunning { startTimer() }
    }
    
    internal func startTimer() {
        instance.state.isRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .default)
        timerHandler = timer.connect()
    }
    
    internal func stopTimer() {
        timerHandler?.cancel()
        timerHandler = nil
    }
    
    internal func stop() {
        stopTimer()
        instance.state.isRunning = false
        instance.state.disappearTime = nil
        instance.state.elapsed = 0
        nextIteration()
    }
    
    internal func run() {
        if instance.state.elapsed < currentSettings.duration,
           instance.state.isRunning == true
        {
            instance.state.elapsed += currentSettings.interval
        } else {
            stop()
        }
    }
    
    internal func nextIteration() {
        instance.state.currentSettingsIteration += 1
        instance.state.currentSettingsIteration = instance.state.currentSettingsIteration
        % instance.settings.phases.count
    }
}
