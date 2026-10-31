import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

Scope {

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40

            // color: "#1d1d20"
            color: "transparent"

            GradientOutline {
                anchors.fill: parent

                WidgetWorkspaces {
                    FlexboxLayout.alignSelf: FlexboxLayout.AlignStart
                }

                WidgetClock {
                    FlexboxLayout.alignSelf: FlexboxLayout.AlignCenter
                }
            }
        }
    }
}
