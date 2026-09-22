import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQml.Models
import "./Notifications"

PanelWindow {
  property bool centerOpen: false
  property var notServer
  property var default_x: 1290
  signal toggle()

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  mask: Region { item: centerOpen ? fullScreenCatcher : null }

  onToggle: {
    if (centerOpen) {
      mainRect.x = default_x
    }
    else {
      mainRect.x = default_x + 600
    }
  }

  Item {
    id: fullScreenCatcher
    anchors.fill: parent

    MouseArea {
      anchors.fill: parent
      onClicked: centerOpen = false
    }

    Rectangle {
      id: mainRect
      anchors {
        top: parent.top
        bottom: parent.bottom
        rightMargin: 18
        topMargin: 18
        bottomMargin: 54
      }
      x: default_x + 600
      width: 400
      color: "#70000000"
      border.width: 3
      border.color: Colors.md3.primary
      radius: 12

      MouseArea {
        anchors.fill: parent
        onClicked: {}
      }

      Behavior on x {
        SpringAnimation {
          spring: 10
          damping: 0.6
        }
      }

      Rectangle { // notification history
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

        RowLayout {
          id: headerRow
          anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 12
          }

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

        ListView {
          id: historyListView
          anchors {
            top: headerRow.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 12
            bottomMargin: 12
          }
          clip: true
          spacing: 12

          model: notServer.history

          delegate: PopUp {
            id: historyCard
            width: historyListView.width - 24
            history: notServer.history
            autoExpire: false

            ListView.onRemove: SequentialAnimation {
              PropertyAction { target: historyCard; property: "ListView.delayRemove"; value: true }
              ParallelAnimation {
                NumberAnimation { target: historyCard; property: "opacity"; to: 0; duration: 200 }
                NumberAnimation { target: historyCard; property: "x"; to: -100; duration: 200 }
              }
              PropertyAction { target: historyCard; property: "ListView.delayRemove"; value: false }
            }
          }

          add: Transition {
            NumberAnimation { properties: "x,y"; from: 100; duration: 120 }
          }

          addDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 220 }
          }

          removeDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 220 }
          }
        }
      }
    }
  }
}