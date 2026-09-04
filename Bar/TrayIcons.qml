import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Repeater {
  model: SystemTray.items
  delegate: IconImage {
    id: trayIcon
    required property SystemTrayItem modelData
    source: modelData.icon
    width: 20
    height: 20

    QsMenuAnchor {
      id: trayMenu
      menu: trayIcon.modelData.menu
      anchor.item: trayIcon   // auto-computes position from this item
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.LeftButton)
          trayIcon.modelData.activate()
        else if (mouse.button === Qt.RightButton)
          trayMenu.open()
      }
      onEntered: {
        if (trayIcon.modelData.hasMenu)
          trayMenu.open()
      }
    }
  }
}
