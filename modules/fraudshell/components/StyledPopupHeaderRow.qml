// Modified from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/StyledPopupHeaderRow.qml

import QtQuick
import qs

Row {
    id: root
    required property var icon
    required property var label
    spacing: 5

    Glyph {
        anchors.verticalCenter: parent.verticalCenter
        fill: 0
        font.weight: Font.DemiBold
        text: root.icon
        iconSize: Sizes.font.large
        color: "#FFFFFF"
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.label
        font {
            weight: Font.DemiBold
            pixelSize: Sizes.font.normal
            family: "VCR OSD Mono"
        }
        color: "#FFFFFF"
    }
}
