pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs
import qs.components

StyledWidget {
    id: root

    property var currentProfile: PowerProfiles.profile
    readonly property string degraded: PowerProfiles.degradationReason.toString()

    barContent: Glyph {
        id: widgetRoot
        anchors.verticalCenter: parent.verticalCenter
        fill: 1
        font.weight: Font.DemiBold
        text: {
	        switch (currentProfile.toString()) {
	        	case "0": return "leaf";
	        	case "1": return "scale";
	        	case "2": return "flame";
	        }
        }
        iconSize: Sizes.widgetGlyphSize
        color: "#FFFFFF"
    }

    hoverContent: ColumnLayout {
        id: popupLayout
        anchors.centerIn: parent
        spacing: 4

        StyledPopupHeaderRow {
            icon: "circle-gauge"
            label: "Power Profiles"
        }

        StyledPopupValueRow {
            visible: true
            icon: ""
            label: "Profile: "
            value: {
	            switch (currentProfile.toString()) {
	            	case "0": return "Power Saver";
	            	case "1": return "Balanced";
	            	case "2": return "Performance";
	            }
            }
        }
    }

    onClicked: currentProfile = (currentProfile + 1) % 3;

}
