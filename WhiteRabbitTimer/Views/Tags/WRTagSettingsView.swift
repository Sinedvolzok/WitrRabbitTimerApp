//
//  WRTagSettingsView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 09.09.2025.
//

import SwiftUI
import SwiftData

struct WRTagSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var editMode: WREditMode
    @Binding var isPresented: Bool
    
    @State private var title: String = "Title"
    @State private var selectedIcon: WRTimer.Icon = .tree
    @State private var selectedColor: WRColor = .blue

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        "Template Name",
                        text: $title,
                        prompt: Text("Name of your template"),
                        axis: .horizontal
                    )
                    WRPickerView(selected: $selectedIcon,
                                 columnsCount: 6,
                                 label: Label("Selct Icon",
                                              systemImage: "photo.on.rectangle.angled"))
                    { icon in
                        Image(systemName: icon.rawValue)
                            .symbolVariant(icon == selectedIcon ? .fill : .none)
                    }
                    WRPickerView(selected: $selectedColor,
                                 label: Label("Selct Color",
                                              systemImage: "swatchpalette"))
                    { color in
                        Circle()
                            .fill(color.value)
                            .stroke(.secondary, lineWidth: 0.4)
                            .frame(width: 36)
                            .overlay {
                                Circle().fill(.background).opacity(0.6)
                                    .scaleEffect(color == selectedColor ? 0.7 : 0.0)
                            }
                    }
                } header:  {
                    Text("info")
                }
            }
            .navigationTitle("Setup Tag")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        switch editMode {
                        case .onEdit(let id):
                            let descriptor = FetchDescriptor<WRTag>(
                                predicate: #Predicate { $0.id == id }
                            )
                            if
                            let tag = try? modelContext.fetch(descriptor).first
                            {
                                tag.title = title
                                tag.iconName = selectedIcon.rawValue
                                tag.color = selectedColor
                            }
                        case .onCreation:
                            let tag = WRTag(
                                title: title,
                                color: selectedColor,
                                iconName: selectedIcon.rawValue
                            )
                            modelContext.insert(tag)
                        }
                        isPresented = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .onAppear {
                switch editMode {
                case .onEdit(let id):
                    let descriptor = FetchDescriptor<WRTag>(
                        predicate: #Predicate { $0.id == id }
                    )
                    if
                        let tag = try? modelContext.fetch(descriptor).first
                    {
                        title = tag.title
                        selectedIcon = WRTimer.Icon(rawValue: tag.iconName) ?? selectedIcon
                        selectedColor = tag.color
                    }
                case .onCreation:
                    print("hello")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var editMode: WREditMode = .onCreation
    @Previewable @State var isPresented: Bool = true
    WRTagSettingsView(
        editMode: $editMode,
        isPresented: $isPresented)
}
