//
//  AssertSnapshot.swift
//  PragueOAPISwiftUITests
//
//  Created by Rostislav Babáček on 12.03.2024.
//

import SnapshotTesting
import SwiftUI
import XCTest

let devices = [
    ViewImageConfig.iPhone13ProMax,
    .iPhone8,
    .iPadPro12_9,
]

/// Checks if the given view matches the image references on the disk.
///
/// - Parameters:
///    - layout: The size constraint for a snapshot (similar to PreviewLayout). Leave empty if you want to run snapshots on preselected devices.
public func AssertSnapshot<View: SwiftUI.View>(
    _ view: View,
    layout: SwiftUISnapshotLayout? = nil,
    record: Bool = false,
    line: UInt = #line,
    file: StaticString = #file,
    function: String = #function
) {
    let strategies: [Snapshotting<View, UIImage>]
    if let layout = layout {
        strategies = imageStrategies(layout: layout)
    } else {
        strategies = devices.flatMap {
            imageStrategies(layout: .device(config: $0))
        }
    }

    assertSnapshots(
        matching: view,
        as: strategies,
        record: record,
        file: file,
        testName: function,
        line: line
    )
}

// MARK: - Helpers

private func imageStrategies<View: SwiftUI.View>(
    layout: SwiftUISnapshotLayout
) -> [Snapshotting<View, UIImage>] {
    [
        .image(
            drawHierarchyInKeyWindow: false,
            layout: layout,
            traits: .init(userInterfaceStyle: .light)
        ),
        .image(
            drawHierarchyInKeyWindow: false,
            layout: layout,
            traits: .init(userInterfaceStyle: .dark)
        ),
    ]
}
