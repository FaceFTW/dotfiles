pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Item {

    component WorkspaceIPC: Item {
        id: ipc_root

        property int active: 1
        property int amount: 6

        property var switchWorkspace: w => {
            console.log(`We are switching from workspace ${active} to ${w}`);
            Hyprland.dispatch(`hl.dsp.focus({workspace="${w}"})`);
        }

        Component.onCompleted: {
            ipc_root.active = Qt.binding(() => Hyprland.focusedMonitor?.activeWorkspace?.id ?? ipc_root.active);
        }
    }

    component WorkspaceButton: Rectangle {
        id: wksp_btn

        required property int wnum
        property string hover_color

        property bool hovered: false
        property bool active: ipc_root.active === wnum || area.containsMouse
        property int activeMargin: 3
        property int inactiveMargin: 5

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.rightMargin: active ? activeMargin : inactiveMargin
        Layout.leftMargin: active ? activeMargin : inactiveMargin

        radius: 10

        Behavior on color {
            ColorAnimation {
                duration: 1000
                to: wksp_btn.hover_color
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            onClicked: ipc_root.switchWorkspace(parent.wnum)
        }
    }

    WorkspaceIPC {
        id: ipc_root
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        Layout.alignment: Qt.AlignHCenter
        spacing: 1

        Repeater {
            model: ipc_root.amount

            WorkspaceButton {
                required property int modelData
                wnum: modelData + 1
                color: "#FFFFFF"
            }
        }
    }
}
