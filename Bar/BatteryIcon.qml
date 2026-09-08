import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Rectangle { //Battery box
    id: batteryBox
    width: 65
    height: 24
    color: "transparent"
    border.color: "white"
    border.width: 2
    radius: 5
    clip: true
    Layout.alignment: Qt.AlignVCenter

    property var device: UPower.devices.values[0]
    property real pct: (device?.percentage ?? 0) * 100
    property bool charging: device?.state === UPowerDeviceState.Charging

    property int barCount: {
        if (pct >= 90) return 5
        else if (pct >= 70) return 4
        else if (pct >= 40) return 3
        else if (pct >= 20) return 2
        else return 1
    }

    property color barColor: {
        if (pct == 100) return "#00FF00"      // bright green
        else if (pct >= 70) return "#6B8E23" // yellowish dark green
        else if (pct >= 40) return "#9B8B00" // dark yellow
        else if (pct >= 20) return "#8B0000" // dark red
        else return "#4B0000"                     // darkest red
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
