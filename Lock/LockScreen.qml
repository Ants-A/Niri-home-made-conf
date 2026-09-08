import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Controls
import Quickshell.Io


WlSessionLock {
  id: lock


  locked: false

  WlSessionLockSurface {
    color: "#000000"
    Button {
      text: "unlock me"
      onClicked: lock.locked = false
    }

    
  }
}


