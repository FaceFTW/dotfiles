// Modified from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/common/widgets/Glyph.qml

import QtQuick

Text {
    id: root
    property real iconSize: 24
    property real fill: 1
    property real truncatedFill: fill.toFixed(1) // Reduce memory consumption spikes from constant font remapping
    renderType: Text.NativeRendering

    anchors.verticalCenter: parent.verticalCenter

    font {
        hintingPreference: Font.PreferNoHinting
        family: "Lucide"
        pixelSize: iconSize
        weight: Font.DemiBold
        variableAxes: {
            "FILL": truncatedFill,
            // "wght": font.weight,
            // "GRAD": 0,
            "opsz": iconSize
        }
    }
}
