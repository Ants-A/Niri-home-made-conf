import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
//Homemade files
import "./TrayIcons"
import "./BatteryIcon"


Rectangle{
  Component.onCompleted: console.log(SystemTray.items)
  anchors {
    fill: parent
    bottomMargin: 4
    leftMargin: 6
    rightMargin: 6
  }
  color: "#000000"
  opacity: 0.69
  radius: 12

  SystemClock { 
    id: clock
    precision: SystemClock.Seconds
  }

  RowLayout {
    anchors.fill: parent
    anchors.rightMargin: 20
    spacing: 24

    Item { Layout.fillWidth: true } // pushes everything to the right

    Row {
      spacing: 20

      //TrayIcons {}

      BatteryIcon {}

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
