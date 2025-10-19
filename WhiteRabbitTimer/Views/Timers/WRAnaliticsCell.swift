//
//  WRAnaliticsCell.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 19.09.2025.
//

import SwiftUI

struct WRAnalyticsCell: View {
    var settings: WRTimer.Settings
    var tag: WRTag
    var data: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            WRSettingsView(settings: settings)
            WRAnaliticsListCell(tag: tag, date: data)
        }
    }
}

#Preview {
    let analyticsItem = WRAnalyticsItem(
        settings: WRTimer.Settings(),
        startDate: Date(),
        tags: [WRTag(title: "Rainbow", color: .pink, iconName: "rainbow")])
    List {
        NavigationLink {
            Text("Sample link")
        } label: {
            WRAnalyticsCell(
                settings: analyticsItem.settings,
                tag: analyticsItem.tags[0],
                data: analyticsItem.startDate
            )
        }
        .padding()
    }
    
}
