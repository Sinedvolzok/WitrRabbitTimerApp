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
    
    private func createTimer(from template: WRTemplate) -> WRTimer {
        let item = WRAnalyticsItem(
            settings: template.settings,
            startDate: .now,
            tags: [WRTag(title: "templates test", color: .pink, iconName: "tag")]
        )
        modelContext.insert(item)
        let runningTimer = WRTimer(settings: template.settings)
        modelContext.insert(runningTimer)
        return runningTimer
    }
    
    private func createTimer(from anlyticsItem: WRAnalyticsItem) -> WRTimer {
        let item = WRAnalyticsItem(
            settings: anlyticsItem.settings,
            startDate: .now,
            tags: [WRTag(title: "analitics test", color: .pink, iconName: "tag")]
        )
        modelContext.insert(item)
        let runningTimer = WRTimer(settings: anlyticsItem.settings)
        modelContext.insert(runningTimer)
        return runningTimer
    }
    
    @State private var singleSelection: UUID?
    
    var body: some View {
        NavigationStack {
            List(selection: $singleSelection) {
                // Running Timers
                Section(header: Text("Running Timers")) {
                    ForEach(timers) { activeItem in
                        NavigationLink(value: activeItem) {
                            WRActiveTimerCell(
                                settings: activeItem.settings,
                                state: activeItem.state
                            )
                        }
                    }
                    .onDelete { offsets in
                        withAnimation {
                            for index in offsets where index < timers.count {
                                modelContext.delete(timers[index])
                            }
                        }
                    }
                }

                // Templates
                Section(header: Text("Templates")) {
                    ForEach(templates) { templateItem in
                        NavigationLink(value: templateItem) {
                            WRSettingsView(settings: templateItem.settings)
                        }
                    }
                    .onDelete { offsets in
                        withAnimation {
                            for index in offsets where index < templates.count {
                                modelContext.delete(templates[index])
                            }
                        }
                    }
                }

                // Recent Timers
                Section(header: Text("Resent Timers")) {
                    ForEach(items) { analyticsItem in
                        NavigationLink(value: analyticsItem) {
                            WRAnalyticsCell(
                                settings: analyticsItem.settings,
                                tag: analyticsItem.tags.first!,
                                data: analyticsItem.startDate
                            )
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
    #if os(iOS)
                ToolbarItem {
                    EditButton()
                }
    #endif
            }
            .navigationTitle("Timers")
            .navigationDestination(for: WRTemplate.self) { template in
                WRTimerView(timer: createTimer(from: template))
            }
            .navigationDestination(for: WRTimer.self) { timer in
                WRTimerView(timer: timer)
            }
            .navigationDestination(for: WRAnalyticsItem.self) { analyticsItem in
                WRTimerView(timer: createTimer(from: analyticsItem))
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
        print("Offsets to delete: \(offsets), items count: \(items.count)")
        withAnimation {
            for index in offsets where index < items.count {
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
