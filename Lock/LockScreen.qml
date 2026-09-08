import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import ".."


WlSessionLock {
  id: lock
  locked: false

  WlSessionLockSurface {
    Image {
      id: wallpaper
      fillMode: Image.PreserveAspectCrop
      anchors {
        fill: parent
      }
      source: "/home/ant/.config/quickshell/assets/Wallpaper"
      asynchronous: true
    }
    GaussianBlur {
      anchors.fill: wallpaper
      source: wallpaper
      radius: 32
      samples: 32
    }

    color: "#000000"
    Button {
      text: "unlock me"
      onClicked: lock.locked = false
    }

    TextField {
      anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        bottomMargin: 20
      }
      focus: true
      background: Rectangle{
        color: Colors.md3.background
        border.width: 5
        border.color: Colors.md3.on_primary
        radius: 30
      }
      rightPadding: 30
      leftPadding: 30
      placeholderText: "Don't touch it"
      width: 300
      height: 50
      color: Colors.md3.primary
      echoMode: TextInput.Password  
    }
  }
}


