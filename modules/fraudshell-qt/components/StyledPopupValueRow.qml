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
        visible: root.icon !== ""
        text: root.icon
        color: "#FFFFFF"
        iconSize: Sizes.font.large
    }
    Text {
        Layout.fillWidth: true
        Layout.minimumWidth: 0
        text: root.label
        color: "#FFFFFF"
        elide: Text.ElideRight
    }
    Text {
        Layout.fillWidth: true
        Layout.minimumWidth: 0
        // Layout.maximumWidth: root.width * 0.45
        horizontalAlignment: Text.AlignRight
        visible: root.value !== ""
        color: "#FFFFFF"
        elide: Text.ElideLeft
        text: root.value
    }
}
