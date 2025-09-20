//
//  WRAnaliticsCell.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 19.09.2025.
//

import SwiftUI

struct WRAnalyticsCell: View {
    var settings: WRTimer.Settings
//    var data:
    var body: some View {
        HStack {
            WRSettingsView(settings: settings)
        
        }
    }
}

#Preview {
    let settings = WRTimer.Settings()
    WRAnalyticsCell(settings: settings)
}
