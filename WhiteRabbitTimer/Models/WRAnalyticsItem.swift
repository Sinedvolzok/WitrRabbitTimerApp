//
//  WRAnalyticsItem.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//
import Foundation
import SwiftData

@Model
final class WRAnalyticsItem: Setupable {
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var settings: WRTimer.Settings
    var startDate: Date
    var tags: [WRTag]
    
    init(
        settings: WRTimer.Settings,
        startDate: Date,
        tags: [WRTag] = [.init(title: "Default", color: .pink, iconName: "rainbow")]
    ) {
        self.settings = settings
        self.startDate = startDate
        self.tags = tags
    }
}
