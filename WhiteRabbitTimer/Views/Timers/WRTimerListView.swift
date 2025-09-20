//  WRTimerListView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 02.09.2025.
//

import SwiftUI
import SwiftData

struct WRTimerListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WRTimer.settings.title) private var timers: [WRTimer]
    @Query(sort: \WRTemplate.settings.title) private var templates: [WRTemplate]
    @Query(sort: \WRAnalyticsItem.settings.title) private var items: [WRAnalyticsItem]
    
    struct SetupableSection: Identifiable {
        let id: UUID = UUID()
        let title: String
        let items: [any Setupable]
    }
    
    private var sections: [SetupableSection] {
        [
            SetupableSection(title: "Running Timers", items: timers),
            SetupableSection(title: "Templates", items: templates),
            SetupableSection(title: "Resent Timers", items: items)
        ]
    }
    
    private var stuff: [any Setupable] {
        timers + templates + items
    }
    
    @State private var singleSelection: UUID?
    
    var body: some View {
        NavigationStack {
            List(selection: $singleSelection) {
                ForEach(sections) { section in
                    Section(header: Text("\(section.title)")) {
                        ForEach(section.items, id: \.id) { item in
                            NavigationLink(value: item) {
                                
                                    
                                        switch item {
                                        case is WRTimer:
                                            EmptyView()
                                        case let templateItem as WRTemplate:
                                            WRTemplateCell(template: templateItem.settings)
                                        case let analyticsItem as WRAnalyticsItem:
                                            WRAnalyticsCell(settings: analyticsItem.settings)
                                        default:
                                            EmptyView()
                                        }
                                    
                                    Image(systemName: "play")
                                
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: WRTemplate.self) { timer in
                Text("From Templates: \(timer.settings.title)")
                    .onAppear {
                        let item = WRAnalyticsItem(
                            settings: timer.settings,
                            startDate: .now,
                            tags: [WRTag(title: "templates test", color: .pink, iconName: "tag")]
                        )
                        modelContext.insert(item)
                        let runningTimer = WRTimer(settings: timer.settings)
                        modelContext.insert(runningTimer)
                    }
            }
            .navigationDestination(for: WRTimer.self) { timer in
                Text("From Timers: \(timer.settings.title)")
            }
            .navigationDestination(for: WRAnalyticsItem.self) { timer in
                Text("From Analithics: \(timer.settings.title)")
                    .onAppear {
                        let item = WRAnalyticsItem(
                            settings: timer.settings,
                            startDate: .now,
                            tags: [WRTag(title: "analitics test", color: .pink, iconName: "tag")]
                        )
                        modelContext.insert(item)
                        let runningTimer = WRTimer(settings: timer.settings)
                        modelContext.insert(runningTimer)
                    }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = WRTimer.defaultValue
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    WRTimerListView()
        .modelContainer(for: WRTemplate.self, inMemory: true)
        .modelContainer(for: WRTimer.self, inMemory: true)
        .modelContainer(for: WRAnalyticsItem.self, inMemory: true)
}
