pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "MM/dd/yyyy hh:mm:ss AP t");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
