//  WRanalyticsListView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 02.09.2025.
//

import SwiftUI
import SwiftData

struct WRanalyticsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [WRAnalyticsItem]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Analytics Item at \(item.startDate.formatted())")
                    } label: {
                        Text(item.settings.title)
                            .background(
                                Capsule()
                                .fill(item.settings.colorScheme.value.0))
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = WRAnalyticsItem(
                settings: WRTimer.Settings(
                    title: "Eggs",
                    icon: .mountain,
                    colorScheme: .purpleYellow,
                    phase: .init(duration: 60, style: .countdown)
                ),
                startDate: Date())
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
    WRanalyticsListView()
        .modelContainer(for: WRAnalyticsItem.self, inMemory: true)
}
