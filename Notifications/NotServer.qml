import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQml.Models
import ".."

Scope {
  id: root

  property alias history: history 
  ListModel { id: history }

  NotificationServer {
    id: server

    actionsSupported: true
    bodySupported: true
    imageSupported: true

    onNotification: n => {
      history.insert(0, {
        summary: n.summary,
        body: n.body,
        appName: n.appName,
        urgency: n.urgency,
        actions: n.actions,
        obj: n,
        time: Qt.formatDateTime(new Date(), "HH:mm")
      })
      n.tracked = true
    }
  }

  
  PanelWindow { //The notification pop-ups
    anchors {
      bottom: true
      right: true
    }

    margins {
      bottom: 54
      right: 18
    }

    width: 400
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
          history: root.history
        }
      }
    }
  }
}
