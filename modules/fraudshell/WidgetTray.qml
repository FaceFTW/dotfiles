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
    anchors.verticalCenter: parent.verticalCenter

    component SysTrayItem: MouseArea {
        id: trayItemRoot

        required property SystemTrayItem item

        implicitWidth: 32
        implicitHeight: 32
        anchors.verticalCenter: parent.verticalCenter

        acceptedButtons: Qt.LeftButton | Qt.RightButton

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

            source: trayItemRoot.item.icon || Quickshell.iconPath("image-missing")
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectFit
        }

    }

    RowLayout {
        id: trayRoot

        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: SystemTray.items

            delegate: SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData

                Layout.preferredWidth: 28
                Layout.preferredHeight: 28
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
