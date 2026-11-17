pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var popupList: []

    function dismiss(entry) {
        const index = root.popupList.indexOf(entry);
        if (index < 0)
            return;

        root.popupList = root.popupList.filter(item => item !== entry);
        entry.timer?.stop();
        const tracked = notifServer.trackedNotifications.values.find(
            notification => notification.id === entry.notification.id
        );
        tracked?.dismiss();
        entry.destroy();
    }

    function invokeAction(entry, identifier) {
        const tracked = notifServer.trackedNotifications.values.find(
            notification => notification.id === entry.notification.id
        );
        const action = tracked?.actions.find(item => item.identifier === identifier);
        if (!action) {
            console.warn(`Notification action '${identifier}' is no longer available`);
            return;
        }

        action.invoke();
        dismiss(entry);
    }

    Component {
        id: popupNotificationComponent

        QtObject {
            id: entry
            required property var notification
            property bool hovered: false
            property var actions: notification.actions.map(action => ({
                identifier: action.identifier,
                text: action.text
            }))
            property Timer timer: null
            onHoveredChanged: {
                if (!timer)
                    return;
                if (hovered)
                    timer.stop();
                else
                    timer.restart();
            }
        }
    }

    Component {
        id: popupTimerComponent

        Timer {
            required property var entry
            interval: entry.notification.expireTimeout < 0
                ? 7000
                : entry.notification.expireTimeout
            repeat: false
            onTriggered: root.dismiss(entry)
        }
    }

    NotificationServer {
        id: notifServer
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: notification => {
            notification.tracked = true;
            const entry = popupNotificationComponent.createObject(root, {
                notification: notification
            });

            if (!entry) {
                console.error("Could not create a notification popup");
                notification.dismiss();
                return;
            }

            let timer = null;
            if (notification.expireTimeout !== 0) {
                timer = popupTimerComponent.createObject(entry, {
                    entry: entry
                });
                if (!timer) {
                    console.error("Could not create a notification timeout");
                    notification.dismiss();
                    entry.destroy();
                    return;
                }
                entry.timer = timer;
            }

            root.popupList = [...root.popupList, entry];
            if (timer && !entry.hovered)
                timer.start();
        }
    }
}