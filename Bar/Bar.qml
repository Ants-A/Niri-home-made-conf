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
      }
      width: 50
      height: 25
      color: "transparent"
      border.color: "white"
      border.width: 2
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

