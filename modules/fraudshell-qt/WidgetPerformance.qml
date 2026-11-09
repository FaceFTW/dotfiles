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
    implicitWidth: widgetRoot.implicitWidth + Sizes.widgetMarginBothSides

    hoverEnabled: true

    RowLayout {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter

        implicitHeight: Sizes.widgetHeight
        implicitWidth: widgetRoot.implicitWidth + Sizes.widgetMarginBothSides

        Row {
            spacing: 8
            RowLayout {
                id: cpu
                Row {
                    spacing: 4
                    MaterialSymbol {
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
                    }
                }
            }

            RowLayout {
                id: mem
                Row {
                    spacing: 4
                    MaterialSymbol {
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
                    }
                }
            }
        }
    }
}
