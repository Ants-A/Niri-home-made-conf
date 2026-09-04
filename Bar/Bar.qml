import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
//Homemade files
import "./TrayIcons"


Rectangle{
  Component.onCompleted: console.log(SystemTray.items)
  anchors {
    fill: parent
    bottomMargin: 4
    leftMargin: 6
    rightMargin: 6
  }
  color: "#000000"
  opacity: 0.75
  radius: 16

  SystemClock { 
    id: clock
    precision: SystemClock.Seconds
  }

  RowLayout {
    anchors.fill: parent
    anchors.rightMargin: 20
    spacing: 12

    Item { Layout.fillWidth: true } // pushes everything to the right

    Row {
      spacing: 6

      //TrayIcons {}

      Rectangle { //Battery box
        width: 65
        height: 24
        color: "transparent"
        border.color: "white"
        border.width: 1
        radius: 5

        Layout.alignment: Qt.AlignVCenter

        Text {
          anchors.centerIn: parent
          color: "white"
          property var device: UPower.devices.values[0]
          text: (device?.state === UPowerDeviceState.Charging ? "\udb85\udc0b " : "") +
                Math.round((device?.percentage ?? 0) * 100) + "%"
          font.pixelSize: 18
        }
      }

      Rectangle {
        width: 100
        height: 24
        color: "transparent"
        Text { //System clock
          id: clockText
          anchors.centerIn: parent
          color: "white"
          text: Qt.formatDateTime(clock.date, "ddd hh:mm")
          font.pixelSize: 22
        }
      }
    }
  }
}
