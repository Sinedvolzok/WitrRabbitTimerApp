//
//  WRLabel.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 19.09.2025.
//
import SwiftUI

struct WRLabel: View {
    var template: WRTimer.Settings
    var body: some View {
        HStack {
            Label {
                Text(template.title)
                    .fontWeight(.semibold)
                    .padding(.vertical)
            } icon: {
                Image(systemName: template.icon.rawValue)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        template.colorScheme.value.0,
                        template.colorScheme.value.1
                    )
            }
            .symbolVariant(.fill)
            .font(.title3)
        }
    }
}
