import Quickshell
import QtQuick
import QtQuick.Shapes

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      color: "#1d1d20"

      GradientOutline {

      }

      WidgetClock {
        anchors.centerIn: parent

      }
    }
  }
}
