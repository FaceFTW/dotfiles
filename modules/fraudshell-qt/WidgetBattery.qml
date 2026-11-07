// Modified/combined from the following sources
// https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/BatteryIndicator.qml
// https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/BatteryPopup.qml

pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage
    readonly property bool isLow: percentage <= 15 / 100

    implicitWidth: widgetRoot.implicitWidth
    implicitHeight: Sizes.widgetHeight

    hoverEnabled: true

    RowLayout {
        id: widgetRoot
        anchors.fill: root

        Row {
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: "#FFFFFF"
                text: (root.percentage.toFixed(2) * 100).toString() + "%"
                font.pixelSize: Sizes.font.larger
            }

            MaterialSymbol {
                anchors.verticalCenter: parent.verticalCenter
                fill: 0
                font.weight: Font.DemiBold
                text: {
                    if (percentage >= 93)
                        return "battery_android_full";
                    if (percentage >= 78)
                        return "battery_android_6";
                    if (percentage >= 64)
                        return "battery_android_5";
                    if (percentage >= 50)
                        return "battery_android_4";
                    if (percentage >= 35)
                        return "battery_android_3";
                    if (percentage >= 21)
                        return "battery_android_2";
                    if (percentage >= 7)
                        return "battery_android_1";
                    return "battery_android_0";
                }
                iconSize: Sizes.font.hugeass
                color: "#FFFFFF"
            }
        }
    }

    component BatteryPopup: StyledPopup {
        id: popupRoot

        ColumnLayout {
            id: columnLayout
            anchors.centerIn: parent
            spacing: 4

            // Header
            StyledPopupHeaderRow {
                icon: "battery_android_full"
                label: "Battery"
            }

            StyledPopupValueRow {
                visible: {
                    let timeValue = Battery.isCharging ? Battery.timeToFull : Battery.timeToEmpty;
                    let power = Battery.energyRate;
                    return !(Battery.chargeState == 4 || timeValue <= 0 || power <= 0.01);
                }
                icon: "schedule"
                label: Battery.isCharging ? "Time to full:" : "Time to empty:"
                value: {
                    function formatTime(seconds) {
                        var h = Math.floor(seconds / 3600);
                        var m = Math.floor((seconds % 3600) / 60);
                        if (h > 0)
                            return `${h}h, ${m}m`;
                        else
                            return `${m}m`;
                    }
                    if (Battery.isCharging)
                        return formatTime(Battery.timeToFull);
                    else
                        return formatTime(Battery.timeToEmpty);
                }
            }

            StyledPopupValueRow {
                visible: !(Battery.chargeState != 4 && Battery.energyRate == 0)
                icon: "bolt"
                label: {
                    if (Battery.chargeState == 4) {
                        return "Fully charged";
                    } else if (Battery.chargeState == 1) {
                        return "Charging:";
                    } else {
                        return "Discharging:";
                    }
                }
                value: {
                    if (Battery.chargeState == 4) {
                        return "";
                    } else {
                        return `${Battery.energyRate.toFixed(2)}W`;
                    }
                }
            }

            StyledPopupValueRow {
                icon: "heart_check"
                label: "Health:"
                value: `${(Battery.health).toFixed(1)}%`
            }
        }
    }

    BatteryPopup {
        id: batteryPopup
        hoverTarget: root
    }
}
