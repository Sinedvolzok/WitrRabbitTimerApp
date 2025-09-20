//
//  WRTabbarView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 03.09.2025.
//

import SwiftUI
import SwiftData

struct WRTabbarView: View {
    @State private var selection: WRTab = .timers
    var body: some View {
        TabView(selection: $selection) {
            WRTimerListView()
                .tabItem { WRTab.timers.image }
                .tag(WRTab.timers)
            WRTemplateListView()
                .tabItem { WRTab.templates.image }
                .tag(WRTab.templates)
            WRTagListView()
                .tabItem { WRTab.tags.image }
                .tag(WRTab.tags)
            WRanalyticsListView()
                .tabItem { WRTab.analytics.image }
                .tag(WRTab.analytics)
        }
    }
}

enum WRTab: Equatable, Hashable, CaseIterable {
    case timers
    case templates
    case tags
    case analytics
}

extension WRTab {
    var image: some View {
        switch self {
        case .timers:
            Image(systemName: "timer")
        case .templates:
            Image(systemName: "doc.text")
        case .tags:
            Image(systemName: "tag")
        case .analytics:
            Image(systemName: "chart.bar")
        }
    }
}

#Preview {
    WRTabbarView()
}
