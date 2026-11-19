import QtQuick

// Main container rectangle acting as the window outline/border gradient
Rectangle {
    id: windowRoot
    anchors.fill: parent

    default property alias content: innerContent.data

    // Gradient for the border/outline
    gradient: RainbowGradient {}

    radius: 12
    property int strokeWidth: 4

    // Inner rectangle creates the container background and masks the gradient
    Rectangle {
        id: innerContent
        anchors.fill: parent
        anchors.margins: windowRoot.strokeWidth
        color: "#1d1d20"
        radius: Math.max(0, windowRoot.radius - windowRoot.strokeWidth)
    }
}
