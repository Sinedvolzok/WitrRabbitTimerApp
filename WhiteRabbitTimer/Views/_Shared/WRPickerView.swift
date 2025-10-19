//
//  WRPickerView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 12.09.2025.
//

import SwiftUI

typealias Pickerable = CaseIterable & Equatable & Hashable

struct WRPickerView<Element: Pickerable, Label: View, Content: View>: View
where Element.AllCases: RandomAccessCollection {
    @Binding var selected: Element
    var columnsCount: Int = 5
    var label: Label
    @ViewBuilder var content: (Element) -> Content
    
    var body: some View {
        let columns = Array(
            repeating: GridItem(.flexible()),
            count: columnsCount)
        
        VStack(alignment: .leading) {
            label
            LazyVGrid(columns: columns)
            { ForEach(Element.allCases, id: \.self) { element in
                    content(element)
                        .scaleEffect(element == selected ? 1.4 : 1.0)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            withAnimation {
                                selected = element
                            }
                        }
                }
            }
            .padding(.vertical, 8)
        }
    }
    
}

#Preview {
    @Previewable @State var selectedIcon: WRTimer.Icon = .tree
    @Previewable @State var selectedScheme: WRTimer.ColorScheme = .cyanPink
    @Previewable @State var selectedColor: WRColor = .blue
//    WRPickerView()
    List {
        WRPickerView(selected: $selectedIcon,
                     columnsCount: 6,
                     label: Label("Selct Icon",
                            systemImage: "photo.on.rectangle.angled"))
        { icon in
            Image(systemName: icon.rawValue)
                .symbolVariant(icon == selectedIcon ? .fill : .none)
        }
        WRPickerView(selected: $selectedScheme,
                     label: Label("Selct Colors",
                            systemImage: "swatchpalette.fill"))
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
    }
}
