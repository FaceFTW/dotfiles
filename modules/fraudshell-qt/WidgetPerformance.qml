pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import qs.components
import qs.services

StyledWidget {
    id: root

    barContent: RowLayout {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter

        Row {
            spacing: 8
            RowLayout {
                id: cpu
                Row {
                    spacing: 4
                    Glyph {
                        anchors.verticalCenter: parent.verticalCenter
                        fill: 1
                        font.weight: Font.DemiBold
                        text: "cpu"
                        iconSize: Sizes.widgetGlyphSize
                        color: "#FFFFFF"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#FFFFFF"
                        text: (Performance.cpuUsage * 100).toFixed(0).toString() + "%"
                        font.pixelSize: Sizes.font.larger
                        font.family: "VCR OSD Mono"
                    }
                }
            }

            RowLayout {
                id: mem
                Row {
                    spacing: 4
                    Glyph {
                        anchors.verticalCenter: parent.verticalCenter
                        fill: 1
                        font.weight: Font.DemiBold
                        text: "memory-stick"
                        iconSize: Sizes.widgetGlyphSize
                        color: "#FFFFFF"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#FFFFFF"
                        text: (Performance.memoryUsedPercentage * 100).toFixed(0).toString() + "%"
                        font.pixelSize: Sizes.font.larger
                        font.family: "VCR OSD Mono"
                    }
                }
            }
        }
    }
}
