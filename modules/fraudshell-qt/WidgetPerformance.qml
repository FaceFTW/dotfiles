import qs.components
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    anchors.verticalCenter: parent.verticalCenter

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
                    iconSize: 24
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
                    iconSize: 24
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
