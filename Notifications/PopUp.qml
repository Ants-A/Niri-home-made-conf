import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
  id: card
  required property var modelData

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
      source: card.modelData.image || card.modelData.appIcon || ""
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 4

      Text {
        Layout.fillWidth: true
        text: card.modelData.summary
        color: "white"
        font.bold: true
        font.pixelSize: 18
      }
      Text {
        Layout.fillWidth: true
        visible: text  !== ""
        text: card.modelData.body
        color: "white"
      }
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      for (let action of (card.modelData.actions || [])) {
        action.invoke()
      }
      card.modelData.dismiss()
    } 
  }

  Timer {
    id: timeoutTimer
    interval: 5000
    running: true
    repeat: false
    onTriggered: card.modelData.expire()
  }
}
