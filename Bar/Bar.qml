import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower


Rectangle{
  anchors.fill: parent
  color: "#000000"
  opacity: 0.75


  RowLayout {
    anchors {
      fill: parent
    }
    Rectangle {
      anchors {
        right: parent.right
        verticalCenter: parent
        rightMargin: 20
      }
      width: 65
      height: 24
      color: "transparent"
      border.color: "white"
      border.width: 1
      radius: 5
      Text {
        anchors {
          centerIn: parent
        }
        id: batteryText
        color: "white"
        property var device: UPower.devices.values[0]
        text: (device?.state === UPowerDeviceState.Charging ? "\udb85\udc0b" : "") + 
        Math.round((device?.percentage ?? 0) * 100) + "%"
        font.pixelSize: 18
      }
    }
  }
}

