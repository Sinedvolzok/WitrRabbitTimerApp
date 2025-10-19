//
//  WRTemplateSettingsView.swift
//  TestTimer
//
//  Created by Denis Kozlov on 21.08.2025.
//

import SwiftUI

enum WREditMode {
    case onEdit(id: UUID)
    case onCreation
}

struct WRTemplateSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var editMode: WREditMode
    @Binding var isPresented: Bool
    
    @State private var title: String = ""
    @State private var selectedIcon: WRTimer.Icon = .tree

    @State private var selectedScheme: WRTimer.ColorScheme = .cyanPink
    @State private var kidsMode: Bool = false
    
    @State private var duration: Double = 10
    
    @State private var isInterval: Bool = false
    @State private var isIntervalExpanded: Bool = false
    @State private var maxValue: Int = 10
    @State private var actionValue: Double = 15
    @State private var restValue: Double = 5
    @State private var hasLongRest: Bool = false
    @State private var longRestValue: Double = 10
    @State private var evryThIsLong: Int = 3
    
    @State private var hasSignalPoints: Bool = false
    @State private var hasSignalPointsExpanded: Bool = false
    @State private var everySignalPointsValue: Double = 60
    
    @State private var isPaused: Bool = false
    @State private var startTimeFrames: Int = 600
    @State private var timeRemainingFrames: Int = 400
    
    var longRestDescription: String {
        hasLongRest ? ", Long: \(String(format: "%.0f", longRestValue))" : ""
    }
    
    var body: some View {
        NavigationStack {
            Form {
                switch editMode {
                case .onEdit:
                    EmptyView()
                case .onCreation:
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
                    } header:  {
                        Text("info")
                    }
                }
                
                Section {
                    WRPickerView(selected: $selectedScheme,
                                 label: Label("Select Color Scheme", systemImage: "eyedropper"))
                    { scheme in
                        Circle()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: scheme.value.0, location: 0.5),
                                        .init(color: scheme.value.1, location: 0.5),
                                    ],
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                )
                            )
                            .stroke(.secondary, lineWidth: 0.4)
                            .frame(width: 36)
                            .overlay {
                                Circle().fill(.background).opacity(0.6)
                                    .scaleEffect(scheme == selectedScheme ? 0.7 : 0.0)
                            }
                    }
                    
                    Toggle(
                        "Kids Mode",
                        systemImage: "cloud.rainbow.crop",
                        isOn: $kidsMode
                    )
                } header: { Text("visual") }
                
                Section {
                    WRValuesView(
                        title: "Duration",
                        value: duration,
                        systemImage: "gauge.with.needle"
                    )
                    .disabled(isInterval)
                    Slider(value: $duration, in: 0...60,
                           step: 1,
                           minimumValueLabel: Text("0"),
                           maximumValueLabel: Text("60"),
                    ) {
                        Text("Action Minutes")
                    }
                    .disabled(isInterval)
                    
                    Toggle("Interval", systemImage: "timer", isOn: $isInterval)
                    DisclosureGroup(isExpanded: $isIntervalExpanded) {
                        WRValuesView(
                            title: "Action Minutes",
                            value: actionValue,
                            systemImage: "flame"
                        )
                        Slider(value: $actionValue, in: 0...60,
                               step: 1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("60"),
                        ) {
                            Text("Action Minutes")
                        }
                        WRValuesView(
                            title: "Rest Minutes",
                            value: restValue,
                            systemImage: "water.waves"
                        )
                        Slider(value: $restValue, in: 0...30,
                               step: 1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("30"),
                        ) {
                            Text("Rest Minutes")
                        }
                        Toggle("Long Rest", isOn: $hasLongRest)
                        WRValuesView(
                            title: "Long Rest",
                            value: longRestValue,
                            systemImage: "water.waves.and.arrow.trianglehead.down"
                        )
                        Slider(value: $longRestValue, in: 0...30,
                               step: 1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("30"),
                        ) {
                            Text("Long Rest Minutes")
                        }
                        .disabled(!hasLongRest)
                        Stepper(
                            "Every \(evryThIsLong)th rest",
                            value: $evryThIsLong,
                            in: 2...10
                        )
                        .disabled(!hasLongRest)
                    } label: {
                        Text(
                            "Action: \(String(format: "%.0f", longRestValue)), Rest: \(String(format: "%.0f", restValue))\(longRestDescription)"
                        )
                        .foregroundStyle(isInterval ? .primary : .secondary)
                        .padding(.horizontal, 18)
                    }
                    .disabled(!isInterval)
                    
                    Toggle("Signal Points",
                           systemImage: "bell", isOn: $hasSignalPoints)
                    DisclosureGroup(isExpanded: $hasSignalPointsExpanded) {
                        Slider(value: $everySignalPointsValue, in: 0...120,
                               step: 5,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("120"),
                        ) {
                            Text("Every Minutes")
                        }.accentColor(.primary)
                    } label: {
                        Text(
                            "Every \(String(format: "%.0f", everySignalPointsValue)) seconds"
                        )
                        .foregroundStyle(
                            hasSignalPoints ? .primary : .secondary
                        )
                        .padding(.horizontal, 18)
                    }
                    .disabled(!hasSignalPoints)
                    
                } header: { Text("time") }
            }
            .navigationTitle("Setup")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isInterval {
                            if hasLongRest {
                                let settings = WRTimer.Settings(
                                    title: title,
                                    icon: selectedIcon,
                                    colorScheme: selectedScheme,
                                    actionValue: actionValue,
                                    restValue: restValue,
                                    longRestValue: longRestValue,
                                    evryThIsLong: evryThIsLong
                                )
                                modelContext.insert(WRTemplate(settings: settings))
                            } else {
                                let settings = WRTimer.Settings(
                                    title: title,
                                    icon: selectedIcon,
                                    colorScheme: selectedScheme,
                                    actionValue: actionValue,
                                    restValue: restValue
                                )
                                modelContext.insert(WRTemplate(settings: settings))
                            }
                        } else {
                            let settings = WRTimer.Settings(
                                title: title,
                                icon: selectedIcon,
                                colorScheme: selectedScheme,
                                phase: .init(duration: duration, style: .countdown)
                            )
                            modelContext.insert(WRTemplate(settings: settings))
                        }
                        isPresented = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
#endif // os(iOS)
        }
    }
}

struct WRValuesView: View {
    var title: String
    var value: Double
    var systemImage: String
    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            Text(String(format: "%.0f", value)).opacity(0.75)
        }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var editMode: WREditMode = .onCreation
    WRTemplateSettingsView(
        editMode: $editMode,
        isPresented: $isPresented
    )
}
