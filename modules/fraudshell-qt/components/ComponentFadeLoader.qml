//Taken from end-4 illogical impulse
// https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/common/widgets/FadeLoader.qml

import QtQuick

Loader {
    id: root
    property bool shown: true
    property alias fade: opacityBehavior.enabled
    property alias animation: opacityBehavior.animation
    opacity: shown ? 1 : 0
    visible: opacity > 0
    active: opacity > 0

    Behavior on opacity {
        id: opacityBehavior
        animation: NumberAnimation {
            alwaysRunToEnd: true
            duration: 200
            easing.type: Easing.BezierSpline
            easing.bezierCurve: [0.34, 0.80, 0.34, 1.00, 1, 1] // Default, 200ms

        }
    }
}
