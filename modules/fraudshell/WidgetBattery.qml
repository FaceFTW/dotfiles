// Modified/combined from the following sources
// https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/BatteryIndicator.qml
// https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/ii/bar/BatteryPopup.qml

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs
import qs.components
import qs.services

StyledWidget {
    id: root
    anchors.rightMargin: 12
    readonly property var chargeState: Battery.chargeState
    readonly property bool isCharging: Battery.isCharging
    readonly property bool isPluggedIn: Battery.isPluggedIn
    readonly property real percentage: Battery.percentage * 100
    readonly property bool isLow: percentage <= 15 / 100

    barContent: RowLayout {
        id: widgetRoot

        Row {
            spacing: 4

            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: "#FFFFFF"
                text: root.percentage.toString() + "%"
                font.pixelSize: Sizes.font.larger
                font.family: "VCR OSD Mono"
            }

            Glyph {
                anchors.verticalCenter: parent.verticalCenter
                fill: 1
                font.weight: Font.DemiBold
                text: {
                    if (root.percentage >= 0.70)
                        return "battery-full";
                    if (root.percentage >= 0.35)
                        return "battery-medium";
                    if (root.percentage >= 0.2)
                        return "battery-low";
                    return "battery";
                }
                iconSize: Sizes.widgetGlyphSize
                color: "#FFFFFF"
            }

            Glyph {
                visible: root.chargeState === UPowerDeviceState.Charging || root.chargeState === UPowerDeviceState.PendingCharge || root.chargeState === UPowerDeviceState.FullyCharged
                anchors.verticalCenter: parent.verticalCenter
                fill: 1
                font.weight: Font.DemiBold
                text: {
                    if (root.chargeState === UPowerDeviceState.Charging) {
                        return "plug-zap";
                    } else if (root.chargeState === UPowerDeviceState.PendingCharge || root.chargeState === UPowerDeviceState.FullyCharged) {
                        return "plug";
                    } else
                        "";
                }
                iconSize: Sizes.widgetGlyphSize
                color: "#FFFFFF"
            }
        }
    }

    hoverContent: ColumnLayout {
        id: columnLayout
        anchors.centerIn: parent
        spacing: 4

        // Header
        StyledPopupHeaderRow {
            icon: "battery"
            label: "Battery"
        }

        StyledPopupValueRow {
            visible: {
                let timeValue = Battery.isCharging ? Battery.timeToFull : Battery.timeToEmpty;
                let power = Battery.energyRate;
                return !(Battery.chargeState == 4 || timeValue <= 0 || power <= 0.01);
            }
            icon: "timer"
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
            icon: "circle-gauge"
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
            icon: "heart"
            label: "Health:"
            value: `${(Battery.health).toFixed(1)}%`
        }
    }
}
