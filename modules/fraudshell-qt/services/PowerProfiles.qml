pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    property var currentProfile: PowerProfiles.profile
    readonly property string degraded: PowerProfiles.degradationReason.toString()
}
