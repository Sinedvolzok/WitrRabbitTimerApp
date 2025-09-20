//
//  WRTagGridView.swift
//  WhiteRabbitTimer
//
//  Created by Denis Kozlov on 15.09.2025.
//

import SwiftUI

struct WRTagGridView: View {
    var columns = Array(
        repeating:
            GridItem( .flexible(),
                      spacing: 16,
                      alignment: .center
                    ),
        count: 30)
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 16
            ) {
                ForEach(0..<1000) { index in
                    Rectangle().foregroundStyle(.white).cornerRadius(100/2)
                        .frame(
                            width: 200,
//                            width: CGFloat(Int.random(in: 0...150)),
                            height: 100
                        )
                        .offset(x: offsetX(index))
                }
            }
        }
    }
    
    private func offsetX(_ index: Int) -> CGFloat {
        let row = index/30
        
        if row%2 == 0 {
            return 150/2
        }
        
        return 0
    }
}

#Preview {
    WRTagGridView()
}
