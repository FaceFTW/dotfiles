import QtQuick
import QtQuick.Shapes

// Main container shape acting as the window outline/border
Shape {
    id: outlineShape
    anchors.fill: parent
    antialiasing: true

    ShapePath {
        id: path
        strokeWidth: 4 // Thickness of your outline
        fillColor: "transparent" // Inside of the window frame

        // Define the gradient for the stroke
        strokeGradient: LinearGradient {
            x1: 0; y1: 0
            x2: outlineShape.width; y2: outlineShape.height

            GradientStop { position: 0.0; color: "#FA6982" }
            GradientStop { position: 0.2; color: "#FAAD45" }
            GradientStop { position: 0.4; color: "#FAFA00" }
            GradientStop { position: 0.6; color: "#96f06e" }
            GradientStop { position: 0.8; color: "#63c8fa" }
            GradientStop { position: 1.0; color: "#dc6ea5" }
        }

        // Draw a rectangle path matching the window bounds (adjusted for stroke width)
        startX: path.strokeWidth / 2
        startY: path.strokeWidth / 2

        PathRectangle {
            x: path.strokeWidth / 2
            y: path.strokeWidth / 2
            width: outlineShape.width - path.strokeWidth
            height: outlineShape.height - path.strokeWidth
            radius: 12 // Rounded corner radius if desired
        }
    }
}
