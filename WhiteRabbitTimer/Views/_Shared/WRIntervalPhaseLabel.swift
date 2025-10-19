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
    var isActive: Bool = false
    var body: some View {
        Label {
            Text(String(format: "%.0f", value))
        } icon: {
            Image(systemName: imageName)
        }
        .font(.caption)
        .padding(8)
        .background(
            Capsule()
                .fill(isActive ? .ultraThinMaterial : .thickMaterial)
                .stroke(.foreground, style: .init(lineWidth: isActive ? 1 : 0))
        )
    }
}

struct WRIntervalPhaseLabel_Previews: PreviewProvider {
    static var previews: some View {
        WRIntervalPhaseLabel(
            value: 10.0,
            imageName: "arrow.2.circlepath.circle")
    }
}
