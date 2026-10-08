import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
//Homemade files
import "TrayIcons.qml"
import "BatteryIcon.qml"
import ".."


Rectangle{
  anchors {
    fill: parent
    bottomMargin: 4
    leftMargin: 6
    rightMargin: 6
  }
  color: Colors.md3.background_dark
  opacity: 0.69
  radius: 12

  PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

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
      spacing: 14

      //TrayIcons {}

      Text {
        height: 24
        text: "󰖁"
        color: Colors.md3.primary
        font.pixelSize: 18
        visible: Pipewire.defaultAudioSink.audio.muted
      }

      BatteryIcon {}

      Rectangle { //System clock
        implicitWidth: 135
        height: 24
        color: "transparent"
        radius: 8
        border.color: Colors.md3.primary
        border.width: 2
        Text { 
          id: clockText
          anchors.centerIn: parent
          text: Qt.formatDateTime(clock.date, "hh:mm dd MMM")
          font.pixelSize: 20
          font.bold: true
          color: Colors.palette.primary90
        }
      }
    }
  }
}
