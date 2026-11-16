// Modified From https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/StyledPopup.qml
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.components

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
        margins.top: Sizes.barHeight + 8
        margins.bottom: 0

        WlrLayershell.namespace: "quickshell:popup"
        WlrLayershell.layer: WlrLayer.Overlay

        GradientOutline {
            Rectangle {
                id: popupBackground
                readonly property real margin: 2
                anchors {
                    fill: parent
                    topMargin: root.popupBackgroundMargin
                }
                implicitWidth: root.contentItem.implicitWidth + (margin * 2)
                implicitHeight: root.contentItem.implicitHeight + (margin * 2)
                color: "#201f20"
                radius: 12
                children: [root.contentItem]

                // Ensures loaded component is properly anchored
                Component.onCompleted: {
                    root.contentItem.anchors.centerIn = popupBackground;
                }
            }
        }
    }
}
