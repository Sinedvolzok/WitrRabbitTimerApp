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
    
    @State private var path = NavigationPath()
    
    @State private var singleSelection: UUID?
    
    var body: some View {
        NavigationStack(path: $path) {
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
                        Button {
                            let timer = createTimer(from: templateItem)
                            path.append(timer)
                        } label: {
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
                            Button {
                                let timer = createTimer(from: analyticsItem)
                                path.append(timer)
                            } label: {
                                if let firstItem = analyticsItem.tags.first {
                                    WRAnalyticsCell(
                                        settings: analyticsItem.settings,
                                        tag: firstItem,
                                        data: analyticsItem.startDate
                                    )
                                }
                            }
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
                ToolbarItem {
                    Button(action: deleteAllTimersAndAnalytics) {
                        Label("Clean Items", systemImage: "trash")
                    }
                }
    #if os(iOS)
                ToolbarItem {
                    EditButton()
                }
    #endif
            }
            .navigationTitle("Timers")
            .navigationDestination(for: WRTimer.self) { timer in
                WRTimerView(timer: timer)
            }
        }
    }
    
    private func createTimer(from template: some Setupable) -> WRTimer {
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
    
    private func willNavigateToDetailView() {
        print("Cell will navigate to detail view")
    }
    
    private func addItem() {
        withAnimation {
            let newItem = WRTimer.defaultValue
            modelContext.insert(newItem)
        }
    }
    
    private func deleteAllTimersAndAnalytics() {
        do {
            try modelContext.delete(model: WRTimer.self)
            try modelContext.delete(model: WRAnalyticsItem.self)
        } catch {
            print("Error deleting: \(error.localizedDescription)")
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

