//  WRTemplateListView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 02.09.2025.
//

import SwiftUI
import SwiftData

struct WRTemplateListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WRTemplate.settings.title) var items: [WRTemplate]
    @State private var isSettingsViewExpanded: Bool = false
    @State private var editMode: WREditMode = .onCreation

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    WRTemplateCell(template: item.settings)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Templates")
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
        .sheet(isPresented: $isSettingsViewExpanded) {
            WRTemplateSettingsView(editMode: $editMode,
                               isPresented: $isSettingsViewExpanded)
            .presentationDetents([.medium, .large])
            .presentationBackground(.thinMaterial)
        }
    }

    private func addItem() {
        isSettingsViewExpanded = true
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
    WRTemplateListView()
        .modelContainer(for: WRTemplate.self, inMemory: true)
}
