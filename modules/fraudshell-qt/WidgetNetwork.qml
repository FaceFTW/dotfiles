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
        if (ethernet) return "lan"
        if (!wifiEnabled) return "signal_wifi_off"
        if (wifiStatus === "disconnected") return "wifi_find"
        if (wifiStatus === "connecting") return "signal_wifi_statusbar_not_connected"
        if (wifiStatus === "connected" && Network.active) {
            const strength = Network.active.strength ?? 0
            if (strength > 83) return "signal_wifi_4_bar"
            if (strength > 67) return "network_wifi"
            if (strength > 50) return "network_wifi_3_bar"
            if (strength > 33) return "network_wifi_2_bar"
            if (strength > 17) return "network_wifi_1_bar"
            return "signal_wifi_0_bar"
        }
        return "signal_wifi_bad"
    }

    function formatStrengthLabel(strength) {
        if (strength >= 80) return "Excellent"
        if (strength >= 60) return "Good"
        if (strength >= 40) return "Fair"
        if (strength >= 20) return "Poor"
        return "Very Poor"
    }

    MaterialSymbol {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter
        fill: 1
        font.weight: Font.DemiBold
        text: root.networkIcon()
        iconSize: 28
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
                icon: root.ethernet ? "devices" : "network_wifi"
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
                icon: "check_circle"
                label: "Status:"
                value: "Connected"
            }

            StyledPopupValueRow {
                visible: root.wifiStatus === "disconnected"
                icon: "disconnected"
                label: "Status:"
                value: "Disconnected"
            }

            StyledPopupValueRow {
                visible: root.wifiStatus === "limited"
                icon: "warning"
                label: "Status:"
                value: "Limited Connectivity"
            }

            StyledPopupValueRow {
                visible: root.wifiStatus === "connected" && !root.ethernet && root.networkStrength < 20
                icon: "lightbulb"
                label: "Tip:"
                value: "Signal is weak. Consider moving closer to the router."
            }
        }
    }

    NetworkHoverPopup {
        id: networkHoverPopup
        hoverTarget: root
    }
}
