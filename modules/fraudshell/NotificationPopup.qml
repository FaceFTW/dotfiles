pragma ComponentBehavior: Bound

import qs
import qs.services
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    PanelWindow {
        visible: NotificationsService.popupList.length > 0
        screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0] ?? null

        WlrLayershell.namespace: "quickshell:notificationPopup"
        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 0

        anchors {
            top: true
            right: true
        }

        mask: Region {
            item: notificationList
        }

        color: "transparent"
        implicitWidth: 380
        implicitHeight: notificationList.implicitHeight + 16
        margins {
            top: Sizes.barHeight + 8
            right: 8
        }

        ColumnLayout {
            id: notificationList
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 8
            }
            spacing: 8

            Repeater {
                model: NotificationsService.popupList

                delegate: Rectangle {
                    id: card
                    required property var modelData
                    readonly property var notification: modelData.notification

                    Layout.fillWidth: true
                    implicitHeight: cardContents.implicitHeight + 20
                    radius: 10
                    color: "#2c2525"
                    border.color: "#5e5086"
                    border.width: 1

                    HoverHandler {
                        onHoveredChanged: card.modelData.hovered = hovered
                    }

                    ColumnLayout {
                        id: cardContents
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Image {
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                source: card.notification.image
                                    || Quickshell.iconPath(card.notification.appIcon || "dialog-information")
                                fillMode: Image.PreserveAspectFit
                                visible: status === Image.Ready
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: card.notification.appName || "Notification"
                                    color: "#c5b8ba"
                                    font.pixelSize: Sizes.font.smaller
                                    elide: Text.ElideRight
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: card.notification.summary
                                    color: "#e6d9db"
                                    font.bold: true
                                    wrapMode: Text.Wrap
                                }
                            }

                            Button {
                                text: "×"
                                onClicked: NotificationsService.dismiss(card.modelData)
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: card.notification.body !== ""
                            text: card.notification.body
                            color: "#e6d9db"
                            wrapMode: Text.Wrap
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            visible: card.modelData.actions.length > 0

                            Repeater {
                                model: card.modelData.actions

                                delegate: Button {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    text: modelData.text
                                    onClicked: NotificationsService.invokeAction(card.modelData, modelData.identifier)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
