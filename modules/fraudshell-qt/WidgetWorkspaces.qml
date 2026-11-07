pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.services
import qs.components

Rectangle {
    id: root
    color: "transparent"
    implicitHeight: Sizes.widgetHeight

    readonly property var workspaceColors: ["#ad495a", "#ad7731", "#adad00", "#66a34b", "#458bad", "#8f476b"]
    readonly property var workspaceActiveColors: ["#fa6982", "#faad45", "#fafa00", "#96f06e", "#63c8fa", "#dc6ea5",]

    component WorkspaceIPC: Item {
        id: ipc_root
        property int active: 1
        property int amount: 6

        function switchWorkspace(w) {
            Hyprland.dispatch(`hl.dsp.focus({workspace="${w}"})`);
        }

        Component.onCompleted: {
            ipc_root.active = Qt.binding(() => Hyprland.focusedMonitor?.activeWorkspace?.id ?? ipc_root.active);
        }
    }

    WorkspaceIPC {
        id: ipc_root
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.topMargin: 0
        implicitWidth: workspaceRow.implicitWidth + anchors.leftMargin

        Row {
            id: workspaceRow
            spacing: Sizes.workspaceButtonGap
            Repeater {
                model: ipc_root.amount

                delegate: WorkspaceButton {
                    required property int modelData
                    wnum: modelData + 1
                }
            }
        }
    }

    component WorkspaceButton: Rectangle {
        id: btn

        required property int wnum
        property var clients: Hyprland.workspaces.values[wnum - 1].toplevels.values

        readonly property var workspaceColor: root.workspaceColors[(btn.wnum - 1) % 6]
        readonly property var activeWorkspaceColor: root.workspaceActiveColors[(btn.wnum - 1) % 6]

        readonly property real iconSize: Sizes.workspaceIconSize
        readonly property real iconGap: Sizes.workspaceIconGap
        readonly property real labelWidth: workspaceLabel.implicitWidth + 12
        readonly property real iconsWidth: clients.length ? clients.length * iconSize + Math.max(0, clients.length - 1) * iconGap + 12 : 0

        implicitWidth: labelWidth + iconsWidth
        implicitHeight: Sizes.widgetHeight
        radius: btn.clients.length > 0 ? 24 : 16
        color: btn.wnum === ipc_root.active || area.containsMouse ? activeWorkspaceColor : workspaceColor
        border.width: 1
        border.color: "#1e1e2e"

        RowLayout {
            anchors.centerIn: parent
            spacing: 4

            Text {
                id: workspaceLabel
                text: String(btn.wnum)
                font.pixelSize: 18
                color: "#11111b"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                visible: btn.clients.length > 0
                spacing: btn.iconGap
                layoutDirection: Qt.LeftToRight

                Repeater {
                    model: btn.clients

                    delegate: ComponentAppIcon {
                        required property HyprlandToplevel modelData
                        property var mainAppIconSource: Quickshell.iconPath(SingletonAppSearch.guessIcon(modelData.wayland.appId), "image-missing")

                        size: btn.iconSize
                        source: mainAppIconSource
                    }
                }
            }
        }

        MouseArea {
            id: area
            hoverEnabled: true
            anchors.fill: parent
            onClicked: ipc_root.switchWorkspace(btn.wnum)
        }
    }
}
