// Modified from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/StyledPopupValueRow.qml

import QtQuick
import QtQuick.Layouts
import qs

RowLayout {
    id: root
    required property string icon
    required property string label
    required property string value
    spacing: 4

    MaterialSymbol {
        text: root.icon
        color: "#FFFFFF"
        iconSize: Sizes.font.large
    }
    Text {
        text: root.label
        color: "#FFFFFF"
    }
    Text {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignRight
        visible: root.value !== ""
        color: "#FFFFFF"
        text: root.value
    }
}
