//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components

Scope {

    LazyLoader {
        id: osdLoader
        active: true
        component: OnScreenDisplay {}
    }

    NotificationPopup {}

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

                RowLayout {
                    id: leftRow
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }

                    Row {

                        WidgetWorkspaces {}
                    }
                }

                RowLayout {
                    id: centerRow
                    anchors.centerIn: parent

                    Row {

                        WidgetClock {}
                    }
                }

                RowLayout {
                    id: rightRow
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    Row {
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
}
