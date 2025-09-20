//
//  WRIntervalPhaseLabel.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 19.09.2025.
//
import SwiftUI

struct WRIntervalPhaseLabel: View {
    var value: Double
    let imageName: String
    var body: some View {
        Label {
            Text(String(format: "%.0f", value))
        } icon: {
            Image(systemName: imageName)
        }
        .padding(8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }
}
