//Different from Glyph which is backed by a font
import QtQuick

Image {
    id: root

    property real size

    // sourceSize.width: size
    // sourceSize.height: size
    width: size
    height: size
    fillMode: Image.PreserveAspectFit

    // paintedHeight: size
    // paintedWidth:size
}
