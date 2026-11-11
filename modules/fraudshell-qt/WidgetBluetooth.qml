pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import qs.components
import qs.services

StyledWidget {
    id: root

    property bool bluetoothEnabled: Bluetooth.enabled
    property int connectedCount: Bluetooth.connectedDevices.length
    property list<var> connectedDevices: Bluetooth.connectedDevices

    function deviceIcon(device) {
        if (!device.connected)
            return "bluetooth-off";
        if (device.deviceClass === "phone")
            return "smartphone";
        if (device.deviceClass === "computer")
            return "monitor-pc";
        if (device.deviceClass === "network")
            return "network";
        if (device.deviceClass === "audio")
            return "headphones";
        if (device.deviceClass === "keyboard")
            return "keyboard";
        if (device.deviceClass === "mouse")
            return "mouse";
        if (device.deviceClass === "printer")
            return "printer";
        return "bluetooth";
    }

    function batteryIcon(batteryPercentage) {
        if (batteryPercentage >= 80)
            return "battery_full";
        if (batteryPercentage >= 60)
            return "battery_6";
        if (batteryPercentage >= 40)
            return "battery_4";
        if (batteryPercentage >= 20)
            return "battery_2";
        return "battery_empty";
    }

    function formatBatteryLabel(batteryPercentage) {
        if (batteryPercentage === undefined || batteryPercentage < 0)
            return "";
        return batteryPercentage + "%";
    }

    barContent: Glyph {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter
        fill: 1
        font.weight: Font.DemiBold
        text: {
            if (!root.bluetoothEnabled)
                return "bluetooth-off";
            if (root.connectedCount === 0)
                return "bluetooth";
            return "bluetooth-connected";
        }
        iconSize: Sizes.widgetGlyphSize
        color: "#FFFFFF"
    }

    hoverContent: ColumnLayout {
        id: popupLayout
        anchors.centerIn: parent
        spacing: 4

        StyledPopupHeaderRow {
            icon: "bluetooth"
            label: "Bluetooth"
        }

        StyledPopupValueRow {
            visible: !root.bluetoothEnabled
            icon: "bluetooth-off"
            label: "Status:"
            value: "Disabled"
        }

        StyledPopupValueRow {
            visible: root.bluetoothEnabled && root.connectedCount === 0
            icon: "bluetooth"
            label: "Status:"
            value: "No devices connected"
        }

        Repeater {
            model: root.connectedDevices

            StyledPopupValueRow {
                icon: root.deviceIcon(modelData)
                label: modelData.name
                value: {
                    const battery = modelData.batteryPercentage;
                    if (battery !== undefined && battery >= 0) {
                        return root.formatBatteryLabel(battery) + " " + root.batteryIcon(battery);
                    }
                    return "";
                }
            }
        }

        StyledPopupValueRow {
            visible: root.connectedCount > 0
            icon: ""
            label: "Connected Devices:"
            value: root.connectedCount
        }
    }
}
