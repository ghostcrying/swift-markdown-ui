#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
struct ImageView: View {
    @Environment(\.theme.image) private var image
    @Environment(\.imageProvider) private var imageProvider
    @Environment(\.imageBaseURL) private var baseURL
    
    private let data: RawImageData
    
    init(data: RawImageData) {
        self.data = data
    }
    
    var body: some View {
        self.image.makeBody(
            configuration: .init(
                label: .init(self.label),
                content: .init(block: self.content)
            )
        )
    }
    
    private var label: some View {
        self.imageProvider.makeImage(url: self.url)
            .link(destination: self.data.destination)
            .accessibilityLabel(self.data.alt)
    }
    
    private var content: BlockNode {
        if let destination = self.data.destination {
            return .paragraph(
                content: [
                    .link(
                        destination: destination,
                        children: [.image(source: self.data.source, children: [.text(self.data.alt)])]
                    )
                ]
            )
        } else {
            return .paragraph(
                content: [.image(source: self.data.source, children: [.text(self.data.alt)])]
            )
        }
    }
    
    private var url: URL? {
        URL(string: self.data.source, relativeTo: self.baseURL)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension ImageView {
    init?(_ inlines: [InlineNode]) {
        guard inlines.count == 1, let data = inlines.first?.imageData else {
            return nil
        }
        self.init(data: data)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension View {
    fileprivate func link(destination: String?) -> some View {
        self.modifier(LinkModifier(destination: destination))
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
private struct LinkModifier: ViewModifier {
    @Environment(\.baseURL) private var baseURL
    @Environment(\.openURL) private var openURL
    
    let destination: String?
    
    var url: URL? {
        self.destination.flatMap {
            URL(string: $0, relativeTo: self.baseURL)
        }
    }
    
    func body(content: Content) -> some View {
        if let url {
            Button {
                self.openURL(url)
            } label: {
                content
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }
}
