import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
    id: trayWidget

    property int margins: 2
    property bool showDebugOverlay: true

    implicitWidth: trayRoot.implicitWidth + margins * 2
    implicitHeight: trayRoot.implicitHeight + margins * 2

    Component.onCompleted: Qt.callLater(() => {
        console.log("WidgetTray root:",
                    "x/y", x, y,
                    "size", width, height,
                    "implicit", implicitWidth, implicitHeight)
        console.log("WidgetTray row:",
                    "x/y", trayRoot.x, trayRoot.y,
                    "size", trayRoot.width, trayRoot.height,
                    "implicit", trayRoot.implicitWidth, trayRoot.implicitHeight)
    })

    component SysTrayItem: MouseArea {
        id: trayItemRoot

        required property SystemTrayItem item

        implicitWidth: 32
        implicitHeight: 32

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onWidthChanged: console.log("Tray delegate width:", width, "item:", item)
        onHeightChanged: console.log("Tray delegate height:", height, "item:", item)

        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                item.activate()
                break
            case Qt.RightButton:
                if (item.hasMenu)
                    menu.open()
                break
            default:
                console.log("Button event unhandled:", event.button)
            }
        }

        // Diagnostic background: if this is visible but the icon isn't,
        // delegate placement is working and the issue is with image rendering.
        Rectangle {
            anchors.fill: parent
            visible: trayWidget.showDebugOverlay
            color: "#1d1d1dff"
            border.color: "#1d1d1d"
            border.width: 1
        }

        QsMenuAnchor {
            id: menu
            menu: trayItemRoot.item.menu
            anchor.window: trayItemRoot.QsWindow.window
            anchor.rect.x: trayItemRoot.x + (trayItemRoot.QsWindow.contentItem?.width ?? 0)
            anchor.rect.y: trayItemRoot.y
            anchor.rect.height: trayItemRoot.height * 3
        }

        Image {
            id: icon

            // System tray item.icon may already be an image:// URL.
            source: trayItemRoot.item.icon || Quickshell.iconPath("image-missing")
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit

            onStatusChanged: console.log(
                "Tray image:",
                "raw icon", trayItemRoot.item.icon,
                "source", source,
                "status", status,
                "item size", width, height,
                "source size", sourceSize.width, sourceSize.height,
                "painted size", paintedWidth, paintedHeight
            )
        }

        Component.onCompleted: Qt.callLater(() => {
            console.log("Tray delegate:",
                        "x/y", x, y,
                        "size", width, height,
                        "visible", visible,
                        "parent size", parent.width, parent.height,
                        "icon", item.icon)
        })
    }

    RowLayout {
        id: trayRoot

        anchors.centerIn: parent
        spacing: 0

        Repeater {
            model: SystemTray.items

            delegate: SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData

                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
            }

            Component.onCompleted:
                console.log("Initial tray count:", count)

            onItemAdded: (index, delegate) => {
                console.log("Tray item added:", index,
                            "count:", count,
                            "delegate size:", delegate.width, delegate.height)
            }
        }
    }
}
