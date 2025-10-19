//
//  DynamicStack.swift
//  TestTimer
//
//  Created by Denis Kozlov on 01.07.2025.
//

import SwiftUI

struct DynamicStack: View {
    @State private var isExpanded = false
    var body: some View {
        
        ZStack {
            if isExpanded {
                Image("patternTest").resizable(
                    capInsets: EdgeInsets(
                        top: 23,
                        leading: 23,
                        bottom: 23,
                        trailing: 23),
                    resizingMode: .tile
                )
                .ignoresSafeArea()
            }
            DStack {
                Spacer()
                Image(systemName: "moon.stars.fill")
                        .padding()
                Button("matGlassMaterial") { isExpanded.toggle() }
                    
                Button("matGlassMaterial") { isExpanded.toggle() }
                    .background(Material.ultraThin)
                Button("matGlassMaterial") { isExpanded.toggle() }
//                    .background(Material.matGlassMaterial)
                Button("matGlassMaterial") { isExpanded.toggle() }
//                    .background(Material.matGlassMaterial)
                Spacer()
            }
            .buttonStyle(ActionButtonStyle())
            .safeAreaPadding()
        }
    }
}

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fixedSize()
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.primary)
            .presentationCornerRadius(10)
    }
}

struct DStack<Content: View>: View {
    var horizontalAlignment = HorizontalAlignment.center
    var verticalAlignment = VerticalAlignment.center
    var spacing: CGFloat?
    var isOpposite: Bool = false
    @ViewBuilder var content: () -> Content
    @Environment(\.sizeData) private var sizeData
    var body: some View {
        let isPortraitAndsOpposite = isOpposite ? !sizeData.isPortrait : sizeData.isPortrait
        switch isPortraitAndsOpposite {
        case true:
            vStack
        case false:
            hStack
        }
    }
}

private extension DStack {
    var hStack: some View {
        HStack(alignment: verticalAlignment, spacing: spacing, content: content)
    }
    var vStack: some View {
        VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
    }
}

#Preview {
    DynamicStack()
}
