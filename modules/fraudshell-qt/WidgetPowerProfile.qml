pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import qs.components
import qs.services

MouseArea {
    id: root

    implicitHeight: Sizes.widgetHeight
    implicitWidth: widgetRoot.implicitWidth + 4

    hoverEnabled: true

    Glyph {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter
        fill: 1
        font.weight: Font.DemiBold
        text: "speed_4"
        iconSize: 28
        color: "#FFFFFF"
    }

    component PowerProfilePopup: StyledPopup {
        id: popupRoot

        ColumnLayout {
            id: popupLayout
            anchors.centerIn: parent
            spacing: 4

            StyledPopupHeaderRow {
                icon: "readiness_score"
                label: "Power Profiles"
            }

            StyledPopupValueRow {
                visible: true
                icon: ""
                label: "Profile: "
                value: PowerProfiles.currentProfile.toString()
            }
        }
    }

    PowerProfilePopup {
        id: ppPopup
        hoverTarget: root
    }
}
