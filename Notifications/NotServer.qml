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

      // 3. Prepend it to our custom popup model so it spawns at index 0 (the bottom)
      activePopupsModel.insert(0, { "notification": n })
      
      // 4. Listen for when the notification gets closed/dismissed to remove it from the screen
      n.closed.connect(function() {
        for (let i = 0; i < activePopupsModel.count; i++) {
          if (activePopupsModel.get(i).notification === n) {
            activePopupsModel.remove(i, 1)
            break
          }
        }
      })
    }
  }

  ListModel {
    id: activePopupsModel
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
      clip: false
      interactive: false
      model: activePopupsModel
      verticalLayoutDirection: ListView.BottomToTop

      // Anchor to the bottom of the window via an explicit height + y,
      // so the whole stack grows upward smoothly
      height: Math.min(contentHeight, parent.height)
      y: parent.height - height

      delegate: PopUp {
        history: root.history
      }

      add: Transition {
        ParallelAnimation {
          NumberAnimation { property: "opacity"; to: 100; from: 0; duration: 200 }
          NumberAnimation { properties: "x,y"; from:100; duration: 100 }
        }
      }

      addDisplaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 200 }
      }

      removeDisplaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 200 }
      }

      remove: Transition {
        ParallelAnimation {
          NumberAnimation { property: "opacity"; to: 0; duration: 200 }
          NumberAnimation { property: "x"; to: 400; duration: 200 }
        }
      }
    }
  }
}
