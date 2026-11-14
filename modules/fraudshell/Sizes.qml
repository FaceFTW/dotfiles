pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    // Common Properties
    readonly property real widgetHeight: 36
    readonly property real elevationMargin: 10
    readonly property real widgetMargin: 6
    readonly property real widgetMarginBothSides: root.widgetMargin * 2
    readonly property real widgetGlyphSize: 24

    // Bar Properties
    readonly property real barHeight: 48

    // Workspace Widget Properties
    readonly property real workspaceIconSize: 24
    readonly property real workspaceIconGap: 4
    readonly property real workspaceButtonGap: 4

    readonly property QtObject font: QtObject {
        readonly property int smallest: 10
        readonly property int smaller: 12
        readonly property int smallie: 13
        readonly property int small: 15
        readonly property int normal: 16
        readonly property int large: 17
        readonly property int larger: 19
        readonly property int huge: 22
        readonly property int hugeass: 24
        readonly property int title: huge
    }
}
