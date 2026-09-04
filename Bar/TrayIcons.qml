import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray


Repeater {
  model: SystemTray.items

  delegate: IconImage {
    required property SystemTrayItem modelData
    source: modelData.icon
    width: 20
    height: 20
    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton

      onClicked: mouse => {
        if (mouse.button === Qt.LeftButton)
          modelData.activate()
        else if (mouse.button === Qt.RightButton)
          modelData.display(parent)
      }
    }
  }
}
