import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import ".."

Rectangle { //Battery box
    id: batteryBox
    width: 65
    height: 24
    color: "transparent"
    border.color: Colors.md3.primary
    border.width: 2
    radius: 5
    clip: true
    Layout.alignment: Qt.AlignVCenter

    property var device: UPower.devices.values[0]
    property real pct: (device?.percentage ?? 0) * 100
    property bool charging: device?.state === UPowerDeviceState.Charging

    property int barCount: {
      if (pct >= 80) return 5
      else if (pct >= 60) return 4
      else if (pct >= 30) return 3
      else if (pct >= 10) return 2
      else return 1
    }

    property color barColor: {
      var bat_round = Math.ceil(pct / 10) * 10
      console.log(Colors.palette["primary" + bat_round])
      return Colors.palette["primary" + bat_round]      // bright green
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: batteryBox.border.width
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 2

        Repeater {
            model: 5
            Rectangle {
                Layout.bottomMargin: 2
                Layout.topMargin: 2
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: index < batteryBox.barCount ? batteryBox.barColor : "transparent"
            }
        }
    }

    Text {
        anchors.centerIn: parent
        visible: pct < 100
        color: "white"
        font.pixelSize: 14
        font.bold: true
        text: (batteryBox.charging ? "\udb85\udc0b " : "") + Math.round(batteryBox.pct) + "%"
    }
}
