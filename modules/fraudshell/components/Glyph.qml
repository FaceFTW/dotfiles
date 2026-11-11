// Modified from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/common/widgets/Glyph.qml

import QtQuick

Text {
    id: root
    property real iconSize: 16
    property real fill: 0
    property real truncatedFill: fill.toFixed(1) // Reduce memory consumption spikes from constant font remapping
    renderType: Text.NativeRendering

    font {
        hintingPreference: Font.PreferNoHinting
        family: "Lucide"
        pixelSize: iconSize
        weight: Font.Normal + (Font.DemiBold - Font.Normal) * truncatedFill
        variableAxes: {
            "FILL": truncatedFill,
            // "wght": font.weight,
            // "GRAD": 0,
            "opsz": iconSize
        }
    }
}
