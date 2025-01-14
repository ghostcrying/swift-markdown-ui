#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension Sequence where Element == BlockNode {
    func filterImagesMatching(colorScheme: ColorScheme) -> [BlockNode] {
        self.rewrite { inline in
            switch inline {
            case .image(let source, _):
                guard let url = URL(string: source), url.matchesColorScheme(colorScheme) else {
                    return []
                }
                return [inline]
            default:
                return [inline]
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension URL {
    fileprivate func matchesColorScheme(_ colorScheme: ColorScheme) -> Bool {
        guard let fragment = self.fragment?.lowercased() else {
            return true
        }
        
        switch colorScheme {
        case .light:
            return fragment != "gh-dark-mode-only"
        case .dark:
            return fragment != "gh-light-mode-only"
        @unknown default:
            return true
        }
    }
}
