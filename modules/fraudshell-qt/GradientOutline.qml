import QtQuick
import QtQuick.Layouts

// Main container rectangle acting as the window outline/border gradient
Rectangle {
    id: windowRoot
    anchors.fill: parent

    property alias leftContent: leftRow.data
    property alias centerContent: centerRow.data
    property alias rightContent: rightRow.data

    // Gradient for the border/outline
    gradient: Gradient {
        orientation: Gradient.Horizontal

        GradientStop {
            position: 0.0
            color: "#FA6982"
        }
        GradientStop {
            position: 0.2
            color: "#FAAD45"
        }
        GradientStop {
            position: 0.4
            color: "#FAFA00"
        }
        GradientStop {
            position: 0.6
            color: "#96f06e"
        }
        GradientStop {
            position: 0.8
            color: "#63c8fa"
        }
        GradientStop {
            position: 1.0
            color: "#dc6ea5"
        }
    }

    radius: 12
    property int strokeWidth: 4

    // Inner rectangle creates the container background and masks the gradient
    Rectangle {
        id: innerContent
        anchors.fill: parent
        anchors.margins: windowRoot.strokeWidth
        color: "#1d1d20"
        radius: Math.max(0, windowRoot.radius - windowRoot.strokeWidth)

        RowLayout {
            id: leftRow
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }

        RowLayout {
            id: centerRow
            anchors.centerIn: parent
        }

        RowLayout {
            id: rightRow
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
