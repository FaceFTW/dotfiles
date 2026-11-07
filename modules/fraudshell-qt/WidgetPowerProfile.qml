pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root



    implicitHeight: Sizes.widgetHeight

    hoverEnabled: true

    MaterialSymbol {
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
                value: PowerProfiles.profile.toString()
            }
        }
    }

    PowerProfilePopup {
        id: ppPopup
        hoverTarget: root
    }
}
