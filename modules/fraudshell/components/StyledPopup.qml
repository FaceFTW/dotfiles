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
    property Item positionTarget: hoverTarget
    property bool pinned: false
    default property Item contentItem
    property real popupBackgroundMargin: 0
    signal dismissed

    active: pinned || (hoverTarget && hoverTarget.containsMouse)

    component: PanelWindow {
        id: popupWindow
        color: "transparent"

        anchors {
            top: true
            left: true
            right: root.pinned
            bottom: root.pinned
        }

        implicitWidth: root.pinned ? popupWindow.screen.width : popupContentWidth
        implicitHeight: root.pinned ? popupWindow.screen.height : popupContentHeight
        readonly property real popupContentWidth: popupBackground.implicitWidth + root.popupBackgroundMargin + 20
        readonly property real popupContentHeight: popupBackground.implicitHeight + root.popupBackgroundMargin + 20

        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0
        readonly property real desiredLeft: {
            const point = root.QsWindow?.mapFromItem(root.positionTarget, (root.positionTarget.width - popupContentWidth) / 2, 0);
            return point ? point.x : 0;
        }

        margins.left: root.pinned ? 0 : Math.max(0, Math.min(desiredLeft, popupWindow.screen.width - popupContentWidth))
        margins.top: root.pinned ? 0 : Sizes.barHeight + 8
        margins.bottom: 0

        WlrLayershell.namespace: "quickshell:popup"
        WlrLayershell.layer: WlrLayer.Overlay

        MouseArea {
            visible: root.pinned
            anchors.fill: parent
            onClicked: root.dismissed()
        }

        Item {
            x: root.pinned ? Math.max(0, Math.min(popupWindow.desiredLeft, popupWindow.screen.width - width)) : 0
            y: root.pinned ? Sizes.barHeight + 8 : 0
            width: popupWindow.popupContentWidth
            height: popupWindow.popupContentHeight

            GradientOutline {
                anchors.fill: parent

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
                    children: [insideClickArea, root.contentItem]

                    // Ensures loaded component is properly anchored
                    Component.onCompleted: {
                        root.contentItem.anchors.centerIn = popupBackground;
                    }

                    MouseArea {
                        id: insideClickArea
                        anchors.fill: parent
                        onClicked: {}
                    }
                }
            }
        }
    }
}
