//@ pragma UseQApplication
import QtQuick
import Quickshell

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

            implicitHeight: Sizes.barHeight

            // color: "#1d1d20"
            color: "transparent"

            GradientOutline {
                anchors.fill: parent

                leftContent: Row {
                    WidgetWorkspaces {}
                }

                centerContent: Row {
                    WidgetClock {}
                }

                rightContent: Row {
                	WidgetTray {}
                    WidgetPerformance {}
                    WidgetBluetooth {}
                    WidgetNetwork {}
                    WidgetSound {}
                    // WidgetPowerProfile {}
                    WidgetBattery {}
                }
            }
        }
    }
}
