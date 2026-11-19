//Different from Glyph which is backed by a font
import QtQuick

Image {
    id: root

    property real size

    width: size
    height: size
    fillMode: Image.PreserveAspectFit
}
