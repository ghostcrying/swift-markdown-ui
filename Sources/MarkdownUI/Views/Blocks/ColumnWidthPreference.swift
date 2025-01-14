#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension View {
    func readWidth(column: Int) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear.preference(key: ColumnWidthPreference.self, value: [column: proxy.size.width])
            }
        )
    }
    
    func onColumnWidthChange(perform action: @escaping ([Int: CGFloat]) -> Void) -> some View {
        self.onPreferenceChange(ColumnWidthPreference.self, perform: action)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
private struct ColumnWidthPreference: PreferenceKey {
    static let defaultValue: [Int: CGFloat] = [:]
    
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}
