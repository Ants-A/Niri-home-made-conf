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

  
  PanelWindow { // The notification pop-ups
    anchors {
      bottom: true
      right: true
    }

    margins {
      bottom: 54
      right: 18
    }

    width: 400
    implicitHeight: 900          // fixed; taller than any stack you'll realistically show
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    // Only the popup stack takes input; everything else is click-through
    mask: Region { item: list }

    ListView {
      id: list
      width: parent.width
      spacing: 12
      clip: true
      interactive: false
      model: server.trackedNotifications

      // Anchor to the bottom of the window via an explicit height + y,
      // so the whole stack grows upward smoothly
      height: Math.min(contentHeight, parent.height)
      y: parent.height - height

      Behavior on height {
        SpringAnimation {
          spring: 4
          damping: 0.3
        }
      }

      delegate: PopUp {
        history: root.history
      }
    }
  }
}
