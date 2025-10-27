//
//  WRCircularIndicatorView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 22.10.2025.
//

import SwiftUI

struct WRCircularIndicatorView: View {
    var pending: Double
    var duration: Double
    @State private var rotationDegrees: Double = 0.0
    var body: some View {
        ZStack {
            Circle().stroke(.gray.opacity(0.2),lineWidth: 8)
            Circle()
                .trim(from: 0.0, to: pending/duration)
                .stroke(.black.opacity(0.2),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: pending)
        }
    }
}

#Preview {
    let pending: Double = 108.0
    let duration: Double = 360.0
    WRCircularIndicatorView(pending: pending, duration: duration)
        .padding(40)
}
