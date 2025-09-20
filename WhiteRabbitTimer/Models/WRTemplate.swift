//
//  WRTemplate.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//

import Foundation
import SwiftData

@Model
final class WRTemplate: Setupable {
    var id: UUID = UUID()
    var settings: WRTimer.Settings
    
    init(settings: WRTimer.Settings) {
        self.settings = settings
    }
}
