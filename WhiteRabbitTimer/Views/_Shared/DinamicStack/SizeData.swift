//
//  SizeData.swift
//  TestTimer
//
//  Created by Denis Kozlov on 01.07.2025.
//
import SwiftUI

struct SizeData: Identifiable, Equatable {
  var id: String { "\(size.width)\(size.height)" }
  var isPortrait: Bool { size.width < size.height }
  let size: CGSize
  
  static let empty = SizeData(size: .zero)
  
  static func == (lhs: SizeData, rhs: SizeData) -> Bool {
    return lhs.id == rhs.id
  }
}

struct ReadSizeDataPreferenceKey: @preconcurrency PreferenceKey {
  typealias Value = SizeData
    @MainActor
    static var defaultValue: SizeData = .empty
  
  static func reduce(value: inout SizeData, nextValue: () -> SizeData) {
    value = nextValue()
  }
}

struct ReadSizeDataEnvironmentKey: EnvironmentKey {
  static let defaultValue: SizeData = .empty
}

extension EnvironmentValues {
  var sizeData: SizeData {
    get { self[ReadSizeDataEnvironmentKey.self] }
    set { self[ReadSizeDataEnvironmentKey.self] = newValue }
  }
}

struct ReadSizeData: ViewModifier {
  let sizeData: Binding<SizeData>
  
  func body(content: Content) -> some View {
    content.background {
      GeometryReader { proxy in
        Color.clear.preference(key: ReadSizeDataPreferenceKey.self, value: SizeData(size: proxy.size))
      }
      .onPreferenceChange(ReadSizeDataPreferenceKey.self) { (value) in
        self.sizeData.wrappedValue = value
      }
    }
  }
}

extension View {
  func readSizeData(_ sizeData: Binding<SizeData>) -> some View {
    return modifier(ReadSizeData(sizeData: sizeData))
  }
}
