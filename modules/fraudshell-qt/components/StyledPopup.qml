// Modified From https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/StyledPopup.qml
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs

LazyLoader {
    id: root

    property Item hoverTarget
    default property Item contentItem
    property real popupBackgroundMargin: 0

    active: hoverTarget && hoverTarget.containsMouse

    component: PanelWindow {
        id: popupWindow
        color: "transparent"

        anchors.top: true
        anchors.left: true

        implicitWidth: popupBackground.implicitWidth + root.popupBackgroundMargin + 20
        implicitHeight: popupBackground.implicitHeight + root.popupBackgroundMargin + 20

        mask: Region {
            item: popupBackground
        }

        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        readonly property real desiredLeft: {
            const point = root.QsWindow?.mapFromItem(root.hoverTarget, (root.hoverTarget.width - popupWindow.implicitWidth) / 2, 0);
            return point ? point.x : 0;
        }

        margins.left: Math.max(0, Math.min(desiredLeft, popupWindow.screen.width - popupWindow.implicitWidth))
        margins.top: Sizes.barHeight
        // margins.right: Appearance.sizes.verticalBarWidth
        margins.bottom: Sizes.barHeight

        WlrLayershell.namespace: "quickshell:popup"
        WlrLayershell.layer: WlrLayer.Overlay

        RectangularShadow {
            anchors.fill: parent
            radius: parent.radius
            blur: 10
            // offset: Qt.vector2d(-1.0, -1.0)
            spread: 1
            color: "#AAAAAA"// To understand what it means
            cached: true
        }

        Rectangle {
            id: popupBackground
            readonly property real margin: 10
            anchors {
                fill: parent
                topMargin: Sizes.elevationMargin + root.popupBackgroundMargin * (!popupWindow.anchors.top)
            }
            implicitWidth: root.contentItem.implicitWidth + margin * 2
            implicitHeight: root.contentItem.implicitHeight + margin * 2
            color: "#201f20"
            radius: 12
            children: [root.contentItem]

            border.width: 1
            border.color: "#FFFFFF" // To understand What it look like
        }
    }
}
