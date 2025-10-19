//
//  WRTagListView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 02.09.2025.
//

import SwiftUI
import SwiftData

struct WRTagListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WRTag.title) private var items: [WRTag]
    @State private var isPresentedAddTagSheet: Bool = false
    @State private var editMode: WREditMode = .onCreation

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    WRTagListCell(
                        title: item.title,
                        color: item.color.value,
                        iconName: item.iconName)
                    .swipeActions {
                        
                        Button(role: .destructive) {
                            modelContext.delete(item)
                        }
                        label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button { editItem(id: item.id) }
                        label: {
                            Label("Edit", systemImage: "pencil.line")
                        }
                        .tint(.accentColor)
                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Tags")
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
        .sheet(isPresented: $isPresentedAddTagSheet) {
            WRTagSettingsView(
                editMode: $editMode,
                isPresented: $isPresentedAddTagSheet
            )
            .presentationDetents([.medium])
            .presentationBackground(.thinMaterial)
        }
    }

    private func addItem() {
        isPresentedAddTagSheet = true
        editMode = .onCreation
    }
    
    private func editItem(id: UUID) {
        isPresentedAddTagSheet = true
        editMode = .onEdit(id: id)
    }
    private func deleteItem(id: UUID) {
        
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
    WRTagListView()
        .modelContainer(for: WRTag.self, inMemory: true)
}
