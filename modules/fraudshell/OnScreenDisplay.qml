// Adapted from end-4/dots-hyprland's OnScreenDisplay module.
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs
import qs.components
import qs.services

Scope {
    id: root
    property string protectionMessage: ""
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)
    property string currentIndicator: "volume"
    property bool osdOpen: false
    property var brightnessMonitor: focusedScreen ? Brightness.getMonitorForScreen(focusedScreen) : null

    function triggerOsd() {
        osdOpen = true;
        console.log("OSD Triggered");
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: 2000
        repeat: false
        onTriggered: {
            root.osdOpen = false;
            root.protectionMessage = "";
        }
    }

    Connections {
        target: Brightness
        function onBrightnessChanged() {
            root.protectionMessage = "";
            root.currentIndicator = "brightness";
            root.triggerOsd();
        }
    }

    Connections {
        // Listen to volume changes
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
        function onMutedChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }

    Connections {
        // Listen to protection triggers
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.protectionMessage = reason;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: root.osdOpen

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"
            screen: root.focusedScreen ?? Quickshell.screens[0]

            WlrLayershell.namespace: "quickshell:onScreenDisplay"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                top: true
                left: true
                right: true
            }
            mask: Region {
                item: osdValuesWrapper
            }

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            margins.top: Sizes.barHeight + 8

            visible: osdLoader.active

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter

                Item {
                    id: osdValuesWrapper
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: osdContent.implicitWidth + osdOutline.strokeWidth * 2
                    implicitHeight: osdContent.implicitHeight + osdOutline.strokeWidth * 2
                    clip: true

                    GradientOutline {
                        id: osdOutline

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.osdOpen = false

                            ColumnLayout {
                                id: osdContent
                                spacing: 0

                                OsdValueIndicator {
                                    Layout.alignment: Qt.AlignHCenter
                                    name: root.currentIndicator === "brightness" ? "Brightness" : "Volume"
                                    icon: root.currentIndicator === "brightness" ? "sun" : (Audio.sink?.audio.muted ? "volume-x" : "volume-2")
                                    value: Math.max(0, Math.min(1, root.currentIndicator === "brightness" ? (root.brightnessMonitor?.brightness ?? 0) : (Audio.sink?.audio.volume ?? 0)))
                                }

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    visible: root.protectionMessage !== ""
                                    color: "#8c1d18"
                                    radius: 8
                                    implicitWidth: protectionRow.implicitWidth + 24
                                    implicitHeight: protectionRow.implicitHeight + 16

                                    RowLayout {
                                        id: protectionRow
                                        anchors.centerIn: parent
                                        spacing: 8

                                        Glyph {
                                            text: "triangle-alert"
                                            iconSize: Sizes.font.hugeass
                                            color: "#ffffff"
                                        }
                                        Text {
                                            color: "#ffffff"
                                            wrapMode: Text.Wrap
                                            text: root.protectionMessage
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component OsdValueIndicator: Rectangle {
        id: indicator
        required property string name
        required property string icon
        required property real value

        readonly property real horizontalPadding: 16
        readonly property real verticalPadding: 12

        color: "#201f20"
        radius: 14
        implicitWidth: indicatorContent.implicitWidth + horizontalPadding * 2
        implicitHeight: indicatorContent.implicitHeight + verticalPadding * 2

        RowLayout {
            id: indicatorContent
            anchors.centerIn: parent
            spacing: 12

            Glyph {
                Layout.alignment: Qt.AlignVCenter
                text: indicator.icon
                iconSize: 28
                color: "#ffffff"
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 6

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        color: "#ffffff"
                        font.pixelSize: Sizes.font.small
                        text: indicator.name
                    }
                    Text {
                        color: "#ffffff"
                        font.pixelSize: Sizes.font.small
                        text: `${Math.round(indicator.value * 100)}%`
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitWidth: 180
                    implicitHeight: 8
                    radius: height / 2
                    color: "#49454f"

                    Rectangle {
                        width: parent.width * indicator.value
                        height: parent.height
                        radius: height / 2
                        color: "#d0bcff"
                    }
                }
            }
        }
    }
}
