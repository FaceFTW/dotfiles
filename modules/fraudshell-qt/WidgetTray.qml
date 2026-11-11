// Modified from
// https://github.com/nydragon/nysh/blob/main/src/widgets/systray/SysTray.qml
// https://github.com/nydragon/nysh/blob/main/src/widgets/systray/SysTrayItem.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
    property int margins: 2

    implicitWidth: trayRoot.implicitWidth + Sizes.widgetMargins

    component SysTrayItem: MouseArea {
        id: trayItemRoot

        required property SystemTrayItem item

        Layout.fillWidth: true
        Layout.preferredHeight: parent.width - 4

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            switch (event.button) {
            case Qt.LeftButton:
                item.activate();
                break;
            case Qt.RightButton:
                item.hasMenu && menu.open();
                break;
            default:
                console.log("Buttonevent unhandled");
            }
        }

        QsMenuAnchor {
            id: menu
            menu: trayItemRoot.item.menu
            anchor.window: trayItemRoot.QsWindow.window
            anchor.rect.x: trayItemRoot.x + trayItemRoot.QsWindow.contentItem?.width
            anchor.rect.y: trayItemRoot.y
            anchor.rect.height: trayItemRoot.height * 3
        }

        Image {
            source: Quickshell.iconPath(trayItemRoot.item.icon ?? "image-missing")
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
        }
    }
    RowLayout {
        id: trayRoot
        Layout.alignment: Qt.AlignCenter
        Layout.margins: parent.margins
        width: parent.width

        Repeater {
            model: SystemTray.items
            SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData
            }
        }
    }
}
