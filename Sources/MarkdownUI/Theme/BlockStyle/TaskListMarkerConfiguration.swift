#if canImport(SwiftUI)
import SwiftUI
#endif

/// The properties of a task list marker in a Markdown list.
///
/// The theme ``Theme/taskListMarker`` block style receives a `TaskListMarkerConfiguration`
/// input in its `body` closure.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct TaskListMarkerConfiguration {
    /// Determines whether the item to which the marker applies is completed or not.
    public let isCompleted: Bool
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
extension BlockStyle where Configuration == TaskListMarkerConfiguration {
    /// A task list marker style that displays a checkmark inside a square if the item is completed
    /// or a hollow square if the item is not completed.
    public static var checkmarkSquare: Self {
        BlockStyle { configuration in
            Image(systemName: configuration.isCompleted ? "checkmark.square.fill" : "square")
                .symbolRenderingMode(.hierarchical)
                .imageScale(.small)
                .relativeFrame(minWidth: .em(1.5), alignment: .trailing)
        }
    }
}
