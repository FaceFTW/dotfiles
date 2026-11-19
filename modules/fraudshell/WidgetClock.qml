import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.components
import qs.services

StyledWidget {
    barContent: Item {
        Text {
            anchors.centerIn: parent
            text: Time.time
            color: "#FFFFFF"
            font.family: "VCR OSD Mono"
            font.pixelSize: Sizes.font.larger
        }
    }

    hoverContent: GridLayout {
        columns: 2

        width: 300
        height: 200

        DayOfWeekRow {
            locale: grid.locale

            Layout.column: 1
            Layout.fillWidth: true
        }

        WeekNumberColumn {
            month: grid.month
            year: grid.year
            locale: grid.locale

            Layout.fillHeight: true
        }

        MonthGrid {
            id: grid
            month: Calendar.December
            year: 2015
            locale: Qt.locale("en_US")

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
