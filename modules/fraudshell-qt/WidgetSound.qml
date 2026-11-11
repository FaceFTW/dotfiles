pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import qs.components
import qs.services

StyledWidget {
    id: root

    property var activeSink: Audio.sink
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

    barContent: Glyph {
        id: widgetRoot
        fill: 1
        font.weight: Font.DemiBold
        text: root.volumeIcon()
        iconSize: Sizes.widgetGlyphSize
        color: "#FFFFFF"
    }

    onClicked: Audio.toggleMute()
    onWheel: {
        if (wheel.angleDelta.y > 0) {
            Audio.incrementVolume();
        } else {
            Audio.decrementVolume();
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
            value: Audio.friendlyDeviceName(root.activeSink)
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
