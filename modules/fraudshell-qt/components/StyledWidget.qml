pragma ComponentBehavior: Bound

import QtQuick
import qs
import qs.components

MouseArea {
    id: root

    property Component barContent
    property Component hoverContent
    property var clickAction: null

    implicitWidth: barLoader.implicitWidth + Sizes.widgetMarginBothSides
    implicitHeight: Math.max(Sizes.widgetHeight, barLoader.implicitHeight)



    hoverEnabled: true
    cursorShape: clickAction ? Qt.PointingHandCursor : Qt.ArrowCursor

    onClicked: {
        if (root.clickAction)
            root.clickAction();
    }

    Loader {
        id: barLoader
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        x: Sizes.widgetMargin
        sourceComponent: root.barContent
    }

    StyledPopup {
        hoverTarget: root.hoverContent ? root : null

        Item {
            implicitWidth: hoverLoader.implicitWidth + 4
            implicitHeight: hoverLoader.implicitHeight + 4

            Loader {
                id: hoverLoader
                anchors.centerIn: parent
                sourceComponent: root.hoverContent
            }
        }
    }

    // Ensures loaded component is properly anchored
    // Component.onCompleted: {
    //     root.barContent.anchors.centerIn = root
    // }
}
