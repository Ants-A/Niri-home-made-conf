import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQml.Models
import "./Notifications"

PanelWindow {
  property bool centerOpen: false
  property var notServer

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  // Only intercept input at all when the panel is open.
  // When closed, mask has zero size => clicks pass straight through to whatever's behind.
  mask: Region { item: centerOpen ? fullScreenCatcher : null }

  Item {
    id: fullScreenCatcher
    anchors.fill: parent

    // Backdrop: catches any click that lands outside the visible drawer and closes it.
    MouseArea {
      anchors.fill: parent
      onClicked: centerOpen = false
    }

    Rectangle {
      id: mainRect
      visible: centerOpen
      anchors {
        top: parent.top
        bottom: parent.bottom
        right: parent.right
        rightMargin: 18
        topMargin: 18
        bottomMargin: 54
      }
      width: 400          // fixed drawer width, not parent.width anymore
      color: "#70000000"
      border.width: 3
      border.color: Colors.md3.primary
      radius: 12

      // Swallow clicks inside the drawer so they don't fall through
      // to the backdrop MouseArea and close it.
      MouseArea {
        anchors.fill: parent
        onClicked: {} // do nothing, just eat the event
      }

      Rectangle { // Notification history
        anchors {
          fill: parent
          topMargin: 250
          rightMargin: 10
          leftMargin: 10
          bottomMargin: 10
        }
        border.width: 2
        border.color: Colors.md3.primary_container
        radius: 8
        color: "#30000000"

        ColumnLayout {
          id: centerColumn
          anchors.topMargin: 80
          width: parent.width
          spacing: 12

          RowLayout {
            Layout.topMargin: 12
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.fillWidth: true

            Text {
              Layout.fillWidth: true
              text: "Notifications"
              color: Colors.md3.primary
              font.pixelSize: 18
            }

            Text {
              text: "Clear All"
              color: notServer.history.count > 0 ? Colors.md3.error : Colors.palette.neutral40
              font.pixelSize: 18
              MouseArea {
                anchors.fill: parent
                onClicked: { notServer.history.clear() }
              }
            }
          }

          Repeater {
            model: notServer.history
            delegate: PopUp {
              id: card
              history: notServer.history
              Layout.leftMargin: 10
              Layout.rightMargin: 10
            }
          }
        }
      }
    }
  }
}
