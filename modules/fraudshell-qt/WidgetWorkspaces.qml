pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.services

Rectangle {
    id: root
    color: "transparent"
    implicitHeight: 32

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
        spacing: 2

        Row {
            Repeater {
                model: ipc_root.amount

                delegate: WorkspaceButton {
                    required property int modelData
                    wnum: modelData + 1
                    // clients: ipc_root.workspaceClients[modelData + 1] ?? []
                }
            }
        }
    }

    component WorkspaceButton: Rectangle {
        id: btn

        required property int wnum
        property var clients: Hyprland.workspaces.values[wnum - 1].toplevels.values

        readonly property real iconSize: 28
        readonly property real iconGap: 4
        readonly property real labelWidth: workspaceLabel.implicitWidth + 8
        readonly property real iconsWidth: clients.length ? clients.length * iconSize + Math.max(0, clients.length - 1) * iconGap : 0

        implicitWidth: Math.max(32, labelWidth + iconsWidth + 18)
        implicitHeight: 32
        radius: 24
        color: btn.wnum === ipc_root.active ? "#f38ba8" : "#f2cdcd"
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
            anchors.fill: parent
            onClicked: ipc_root.switchWorkspace(btn.wnum)
        }
    }
}
