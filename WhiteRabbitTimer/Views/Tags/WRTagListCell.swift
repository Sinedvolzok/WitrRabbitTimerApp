//
//  WRTagListCell.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 05.09.2025.
//

import SwiftUI

struct WRTagListCell: View {
    var title: String
    var color: Color
    var iconName: String
    var body: some View {
            Label {
                Text(title)
            } icon: {
                Image(systemName: iconName)
                    .symbolRenderingMode(.monochrome)
            }
            .font(.callout)
            .labelStyle(.titleOnly)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundStyle(color)
            .background(
                Capsule(style: .circular)
                    .fill(color)
                    .opacity(0.4)
            )
    }
}

#Preview {
    WRTagListCell(title: "Default",
                  color: .pink,
                  iconName: "rainbow")
}
