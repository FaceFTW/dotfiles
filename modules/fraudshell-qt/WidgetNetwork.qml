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
    implicitWidth: widgetRoot.implicitWidth + 4

    property string networkName: Network.networkName
    property int networkStrength: Network.networkStrength
    property string wifiStatus: Network.wifiStatus
    property bool wifiEnabled: Network.wifiEnabled
    property bool ethernet: Network.ethernet

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    function networkIcon() {
        if (ethernet)
            return "ethernet-port";
        if (!wifiEnabled)
            return "wifi-off";
        if (wifiStatus === "disconnected")
            return "wifi-off";
        if (wifiStatus === "connecting")
            return "wifi-sync";
        if (wifiStatus === "connected" && Network.active) {
            const strength = Network.active.strength ?? 0;
            if (strength > 75)
                return "wifi";
            if (strength > 50)
                return "wifi-high";
            if (strength > 25)
                return "wifi-low";
            return "wifi-zero";
        }
        return "globe-x";
    }

    function formatStrengthLabel(strength) {
        if (strength >= 80)
            return "Excellent";
        if (strength >= 60)
            return "Good";
        if (strength >= 40)
            return "Fair";
        if (strength >= 20)
            return "Poor";
        return "Very Poor";
    }

    MaterialSymbol {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter
        fill: 1
        font.weight: Font.DemiBold
        text: root.networkIcon()
        iconSize: 24
        color: "#FFFFFF"
    }

    // onClicked: Network.toggleWifi()
    // onWheel: {
    //     if (wheel.angleDelta.y > 0) {
    //         Network.enableWifi(true)
    //     } else {
    //         Network.enableWifi(false)
    //     }
    // }

    component NetworkHoverPopup: StyledPopup {
        id: popupRoot

        ColumnLayout {
            id: popupLayout
            anchors.centerIn: parent
            spacing: 4
            width: 220

            StyledPopupHeaderRow {
                icon: "network"
                label: "Network"
            }

            StyledPopupValueRow {
                icon: root.ethernet ? "ethernet-port" : "wifi"
                label: "Connection Type:"
                value: root.ethernet ? "Ethernet" : "Wi-Fi"
            }

            StyledPopupValueRow {
                visible: root.networkName
                icon: "title"
                label: "Connection Name:"
                value: root.networkName
            }

            StyledPopupValueRow {
                visible: !root.ethernet && Network.active
                icon: "signal"
                label: "Signal Strength:"
                value: root.networkStrength + "% (" + root.formatStrengthLabel(root.networkStrength) + ")"
            }

            StyledPopupValueRow {
                visible: Network.wifiConnecting
                icon: "pending"
                label: "Status:"
                value: "Connecting..."
            }

            StyledPopupValueRow {
                visible: root.wifiStatus === "connected"
                icon: "circle-check"
                label: "Status:"
                value: "Connected"
            }

            StyledPopupValueRow {
                visible: root.wifiStatus === "disconnected"
                icon: "circle-minus"
                label: "Status:"
                value: "Disconnected"
            }

            StyledPopupValueRow {
                visible: root.wifiStatus === "limited"
                icon: "triangle-exclamation-point"
                label: "Status:"
                value: "Limited Connectivity"
            }
        }
    }

    NetworkHoverPopup {
        id: networkHoverPopup
        hoverTarget: root
    }
}
