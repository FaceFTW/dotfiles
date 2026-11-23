pragma ComponentBehavior: Bound

import QtQuick
import qs
import qs.components

MouseArea {
    id: root

    property Component barContent
    property Component hoverContent
    property Component clickContent
    property var clickAction: null
    property bool clickPopupActive: false

    implicitWidth: barLoader.implicitWidth + Sizes.widgetMarginBothSides
    implicitHeight: Math.max(Sizes.widgetHeight, barLoader.implicitHeight)

    hoverEnabled: true
    cursorShape: clickAction || clickContent ? Qt.PointingHandCursor : Qt.ArrowCursor

    onClicked: {
        if (root.clickContent)
            root.clickPopupActive = true;
        else if (root.clickAction)
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
        hoverTarget: !root.clickPopupActive && root.hoverContent ? root : null
        positionTarget: root
        pinned: root.clickPopupActive
        onDismissed: root.clickPopupActive = false

        Item {
            implicitWidth: contentLoader.implicitWidth + 4
            implicitHeight: contentLoader.implicitHeight + 4

            Loader {
                id: contentLoader
                anchors.centerIn: parent
                sourceComponent: root.clickPopupActive ? root.clickContent : root.hoverContent
            }
        }
    }
}
