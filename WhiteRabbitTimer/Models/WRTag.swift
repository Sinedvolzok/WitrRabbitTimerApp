//
//  WRTag.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//
import Foundation
import SwiftData

@Model
final class WRTag: Identifiable {
    @Attribute(.unique)
    var id: UUID = UUID()
    
    @Attribute(.unique)
    var title: String
    var color: WRColor
    var iconName: String
    @Relationship(deleteRule: .cascade, inverse: \WRAnalyticsItem.tags)
    var analytics: [WRAnalyticsItem]
    
    init(title: String, color: WRColor, analytics: [WRAnalyticsItem] = [],
         iconName: String) {
        self.title = title
        self.color = color
        self.analytics = analytics
        self.iconName = iconName
    }
}
