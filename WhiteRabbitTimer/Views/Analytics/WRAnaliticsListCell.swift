//
//  WRAnaliticsListCell.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 15.09.2025.
//

import SwiftUI

struct WRAnaliticsListCell: View {
    var title: String
    var color: Color
    var iconName: String
    var date: Date
    var body: some View {
        HStack {
            WRTagListCell(title: title, color: color, iconName: iconName)
            Spacer()
            VStack(alignment: .trailing){
                Text("\(date.formatted(.dateTime.day().month().year()))")
                Text(
                    "\(date.formatted(.dateTime.hour().minute().second()))"
                )
            }
            .padding()
            .foregroundStyle(.secondary)
            .font(.caption)
        }
    }
}

#Preview {
    NavigationLink(destination: Text("Default")) {
        WRAnaliticsListCell(title: "Default",
                            color: .pink,
                            iconName: "rainbow",
                            date: Date.now
        )
        .padding()
    }
}
