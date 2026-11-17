pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import qs
import qs.components
import qs.services

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

                delegate: GradientOutline {
                    id: notificationOutline
                    Layout.fillWidth: true
                    required property var modelData
                    readonly property var notification: modelData.notification

                    implicitHeight: card.implicitHeight + 8
                    Rectangle {
                        id: card
                        anchors.fill: parent
                        property alias modelData: notificationOutline.modelData
                        readonly property alias notification: notificationOutline.notification

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
                            Column {
                                Layout.fillWidth: true

                                RowLayout {
                                    spacing: 8
                                    Layout.fillWidth: true
                                    anchors.left: parent.left
                                    anchors.right: parent.right

                                    Image {
                                        width: 16
                                        height: 16
                                        Layout.preferredWidth: 32
                                        Layout.preferredHeight: 32
                                        source: card.notification.image || Quickshell.iconPath(card.notification.appIcon || "dialog-information")
                                        fillMode: Image.PreserveAspectFit
                                        visible: status === Image.Ready
                                    }

                                    ColumnLayout {
                                        id: notif_text_top
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

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    MouseArea {
                                        id: x_button
                                        implicitHeight: 16
                                        implicitWidth: 16
                                        Layout.alignment: Qt.AlignRight
                                        Glyph {
                                            text: "x"
                                            color: "#FFFFFF"
                                        }

                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: NotificationsService.dismiss(card.modelData)
                                    }
                                }

                                Text {
                                    width: Math.min(parent.width, 300)
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
    }
}
