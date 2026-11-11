pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

StyledWidget {
    id: root

    property var activeSink: Pipewire.sink
    property real volume: activeSink ? activeSink.audio.volume : 0
    property bool muted: activeSink ? activeSink.audio.muted : false

    function volumeIcon() {
        if (muted)
            return "volume-x";
        if (volume === 0.0)
            return "volume";
        if (volume < 0.5)
            return "volume-1";
        return "volume-2";
    }

    barContent: MaterialSymbol {
        id: widgetRoot
        fill: 1
        font.weight: Font.DemiBold
        text: root.volumeIcon()
        iconSize: Sizes.widgetGlyphSize
        color: "#FFFFFF"
    }

    onClicked: Pipewire.toggleMute()
    onWheel: {
        if (wheel.angleDelta.y > 0) {
            Pipewire.incrementVolume();
        } else {
            Pipewire.decrementVolume();
        }
    }

    hoverContent: ColumnLayout {
        id: popupLayout
        spacing: 4

        StyledPopupHeaderRow {
            icon: "speaker"
            label: "Audio"
        }

        StyledPopupValueRow {
            visible: root.activeSink
            icon: ""
            label: "Default Sink:"
            value: Pipewire.friendlyDeviceName(root.activeSink)
        }

        StyledPopupValueRow {
            visible: true
            icon: "volume-2"
            label: "Volume:"
            value: Math.round(root.volume * 100) + "%"
        }

        StyledPopupValueRow {
            visible: root.muted
            icon: "volume-x"
            label: "Status:"
            value: "Muted"
        }
    }
}
