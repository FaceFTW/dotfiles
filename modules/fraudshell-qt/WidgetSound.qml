pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root

    implicitHeight: Sizes.widgetHeight
    implicitWidth: widgetRoot.implicitWidth + 4

    property var activeSink: Pipewire.sink
    property real volume: activeSink ? activeSink.audio.volume : 0
    property bool muted: activeSink ? activeSink.audio.muted : false

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    function volumeIcon() {
        if (muted) return "volume_mute"
        if (volume < 0.5) return "volume_down"
        return "volume_up"
    }

    MaterialSymbol {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter
        fill: 1
        font.weight: Font.DemiBold
        text: root.volumeIcon()
        iconSize: 28
        color: "#FFFFFF"
    }

    onClicked: Pipewire.toggleMute()
    onWheel: {
        if (wheel.angleDelta.y > 0) {
            Pipewire.incrementVolume()
        } else {
            Pipewire.decrementVolume()
        }
    }

    component SoundHoverPopup: StyledPopup {
       id: popupRoot

        ColumnLayout {
            id: popupLayout
            anchors.centerIn: parent
            spacing: 4
            width: 200

            StyledPopupHeaderRow {
                icon: "audio"
                label: "Audio"
            }

            StyledPopupValueRow {
                visible: root.activeSink
                icon: "devices"
                label: "Default Sink:"
                value: Pipewire.friendlyDeviceName(root.activeSink)
            }

            StyledPopupValueRow {
                visible: true
                icon: "percent"
                label: "Volume:"
                value: Math.round(root.volume * 100) + "%"
            }

            StyledPopupValueRow {
                visible: root.muted
                icon: "block"
                label: "Status:"
                value: "Muted"
            }
        }
    }

    SoundHoverPopup {
        id: soundHoverPopup
        hoverTarget: root
    }
}
