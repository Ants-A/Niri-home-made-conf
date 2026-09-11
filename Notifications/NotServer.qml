import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import ".."

Scope {
  id: root

  NotificationServer {
    id: server

    actionsSupported: true
    bodySupported: true
    imageSupported: true
    onNotification: n => {
      n.tracked = true
      console.log("got:", n.summary, "---", n.body)
    }
  }

  PanelWindow {
    anchors {
      bottom: true
      right: true
    }

    margins {
      bottom: 54
      right: 18
    }

    width: 300
    implicitHeight: colum.implicitHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: colum
      width: parent.width
      spacing: 12

      Repeater {
        model: server.trackedNotifications
        delegate: PopUp {
          id: card
        }
      }
    }
  }
}
