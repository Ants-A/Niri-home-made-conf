import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
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
  color: "#000000"
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

      /*
      IconImage {
        id: icon
        implicitSize: 18
        visible: Pipewire.defaultAudioSink.audio.muted
        source: Quickshell.iconPath("audio-volume-muted-symbolic")
      }
      */
      Text {
        height: 24
        text: "󰖁"
        color: "#eff0f1"
        font.pixelSize: 18
        visible: Pipewire.defaultAudioSink.audio.muted
      }

      BatteryIcon {}

      Rectangle { //System clock
        width: 125
        height: 24
        color: Colors.md3.on_primary_fixed
        radius: 12
        border.width: 20
        border.color: Colors.md3.on_primary_fixed
        Text { 
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
