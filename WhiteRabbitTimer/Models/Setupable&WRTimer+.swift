//
//  WRTimer.swift
//  TestTimer
//
//  Created by Denis Kozlov on 14.08.2025.
//
import SwiftUI
import Foundation
import SwiftData

// MARK: - Protocols
protocol Setupable: Identifiable, Hashable {
    var id: UUID { get }
    var settings: WRTimer.Settings { get }
}

// MARK: - Colors
enum WRColor: String, CaseIterable, Codable {
    case blue
    case cyan
    case gray
    case green
    case indigo
    case mint
    case orange
    case pink
    case purple
    case red
    case teal
    case white
    case yellow
}

extension WRColor {
    var value: Color {
        switch self {
        case .blue:
                Color.blue
        case .cyan:
                Color.cyan
        case .gray:
                Color.gray
        case .green:
                Color.green
        case .indigo:
                Color.indigo
        case .mint:
                Color.mint
        case .orange:
                Color.orange
        case .pink:
                Color.pink
        case .purple:
                Color.purple
        case .red:
                Color.red
        case .teal:
                Color.teal
        case .white:
                Color.white
        case .yellow:
                Color.yellow
        }
    }
}

// MARK: - Icons

extension WRTimer {
    enum Icon: String, CaseIterable, Codable {
        case tree = "tree"
        case mountain = "mountain.2"
        case bird = "bird"
        case book = "book"
        case flame = "flame"
        case stopwatch = "stopwatch"
        case leaf = "leaf"
        case bolt = "bolt"
        case heart = "heart"
        case star = "star"
        case pawprint = "pawprint"
        case umbrella = "umbrella"
        case flag = "flag"
        
        var image: Image {
            Image(systemName: self.rawValue)
        }
    }
}

// MARK: - WRTimer.ColorScheme

extension WRTimer {
    enum ColorScheme: String, CaseIterable, Codable, Hashable {
        case blueGray = "blueGray"
        case cyanPink = "cyanPink"
        case tealMint = "tealMint"
        case purpleYellow = "purpleYellow"
        case indigoOrange = "indigoOrange"
        case greenRed = "greenRed"
        case pinkBlue = "pinkBlue"
        case orangeTeal = "orangeTeal"
        case yellowBlue = "yellowBlue"
    }
}

extension WRTimer.ColorScheme {
    var value: (Color, Color) {
        switch self {
        case .blueGray:
            return (Color.blue, Color.gray)
        case .cyanPink:
            return (Color.cyan, Color.pink)
        case .tealMint:
            return (Color.teal, Color.mint)
        case .purpleYellow:
            return (Color.purple, Color.yellow)
        case .indigoOrange:
            return (Color.indigo, Color.orange)
        case .greenRed:
            return (Color.green, Color.red)
        case .pinkBlue:
            return (Color.pink, Color.blue)
        case .orangeTeal:
            return (Color.orange, Color.teal)
        case .yellowBlue:
            return (Color.yellow, Color.blue)
        }
    }
}
