import SwiftUI

public struct WVStack: View {

  @usableFromInline var alignment: HorizontalAlignment = .center
  @usableFromInline var spacing: CGFloat = 0
  @usableFromInline let content: [AnyView]
  @State private var width: CGFloat = 0

  
  @usableFromInline init(_ alignment: HorizontalAlignment?, _ spacing: CGFloat?, _ content: [AnyView]) {
    if let alignment = alignment {
      self.alignment = alignment
    }
    if let spacing = spacing {
      self.spacing = spacing
    }
    self.content = content
  }
  
  // Work-around for https://bugs.swift.org/browse/SR-11628
  @inlinable public init<Content: View>(alignment: HorizontalAlignment? = nil, spacing: CGFloat? = nil, content: () -> Content) {
    self.init(alignment, spacing, [AnyView(content())])
  }
  
  @inlinable public init<Content: View>(alignment: HorizontalAlignment? = nil, spacing: CGFloat? = nil, content: () -> [Content]) {
    self.init(alignment, spacing, content().map { AnyView($0) })
  }
  
  // Known issue: https://bugs.swift.org/browse/SR-11628
  @inlinable public init(alignment: HorizontalAlignment? = nil, spacing: CGFloat? = nil, @ViewArrayBuilder content: () -> [AnyView]) {
    self.init(alignment, spacing, content())
  }

  public var body: some View {
    GeometryReader { p in
      WrapStack(
        height: p.frame(in: .global).height,
        horizontalAlignment: self.alignment,
        spacing: self.spacing,
        content: self.content
      )
      .anchorPreference(
        key: SizePref.self,
        value: .bounds,
        transform: {
          p[$0].size
        }
      )
    }
    .frame(width: width)
    .onPreferenceChange(SizePref.self, perform: {
      self.width = $0.width
    })
  }
}
