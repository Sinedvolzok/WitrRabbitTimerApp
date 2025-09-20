//
//  WRAnaliticsListCell.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 15.09.2025.
//

import SwiftUI

struct WRAnaliticsListCell: View {
    var tag: WRTag
    var date: Date
    var body: some View {
        HStack {
            WRTagListCell(
                title: tag.title,
                color: tag.color.value,
                iconName: tag.iconName
            )
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
    let tag = WRTag(title: "Rainbow", color: .pink, iconName: "rainbow")
    NavigationLink(destination: Text("Default")) {
        WRAnaliticsListCell(tag: tag, date: Date.now)
        .padding()
    }
}
