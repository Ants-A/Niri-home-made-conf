import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQml.Models
import "./Notifications"

PanelWindow { //The notification pop-ups
  
  property bool centerOpen: false
  property var notServer

  anchors {
    bottom: true
    right: true
    top: true
  }

  margins {
    bottom: 54
    right: 18
    top: 18
  }

  width: 400
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  mask: Region { item: mainRect }

  Rectangle {
    id: mainRect
    visible: centerOpen
    anchors {
      top: parent.top
      bottom: parent.bottom
      right: parent.right
    }
    color: "#70000000"
    width: centerOpen ? parent.width : 0
    height: centerOpen ? parent.height : 0
    border.width: 3
    border.color: Colors.md3.primary
    radius: 12
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
        anchors {
          topMargin: 80
        }
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


