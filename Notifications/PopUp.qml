import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
  id: card
  required property var modelData
  property var history: null

  // Toast repeater: modelData IS the Notification object directly.
  // History repeater: modelData is the ListModel row, whose "obj" field holds the real Notification.
  readonly property var notif: (modelData && modelData.obj !== undefined) ? modelData.obj : modelData

  Layout.fillWidth: true
  Layout.preferredHeight: 80
  radius: 12
  color: "#80000000"
  border.width: 3
  border.color: Colors.md3.primary

  RowLayout {
    anchors {
      fill: parent
      margins: 10
    }
    spacing: 10

    Image {
      Layout.preferredHeight: 36
      Layout.preferredWidth: 36
      Layout.alignment: Qt.AlignCenter
      fillMode: Image.PreserveAspectFit
      visible: source.toString() !== ""
      source: card.notif.image || card.notif.appIcon || ""
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4

      Text {
        Layout.fillWidth: true
        text: card.notif.summary
        color: "white"
        font.bold: true
        font.pixelSize: 18
      }
      Text {
        Layout.fillWidth: true
        visible: text !== ""
        text: card.notif.body
        color: "white"
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      if (card.history) {
        for (let i = 0; i < card.history.count; i++) {
          if (card.history.get(i).obj === card.notif) {
            card.history.remove(i)
            break
          }
        }
      }

      for (let action of (card.notif.actions || [])) {
        action.invoke()
      }
      card.notif.dismiss()
    }
  }

  Timer {
    id: timeoutTimer
    interval: 5000
    running: true
    repeat: false
    onTriggered: card.notif.expire()
  }
}
