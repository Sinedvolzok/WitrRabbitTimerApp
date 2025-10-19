//
//  View+.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 08.10.2025.
//

import SwiftUI

struct View_: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .padding(16)
            .optionalGlassEffect()
    }
}

extension View {
    @ViewBuilder func optionalGlassEffect() -> some View {
        if #available(iOS 26, tvOS 26, macOS 26, *) {
            glassEffect(.regular)
        } else {
            background(.ultraThinMaterial, in: Capsule())
        }
    }
}

#Preview {
    
    View_()
        .safeAreaPadding(20)
}
