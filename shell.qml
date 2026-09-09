//@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick // for Text
import Quickshell.Io
import "./Bar"
import "./Lock"
import "./PopUps"


ShellRoot {
  id: toplevel

  LockScreen {
    id: lock
  }
  
  IpcHandler {
    target: "lock"
    function lock(): void {lock.locked = true;}
  }

  Variants {
    model: Quickshell.screens
    
    PanelWindow {
      anchors {
        bottom: true
        left: true
        right: true
      }
      implicitHeight: 36
      color: "transparent"

      Bar {
        id: bar
      }
    }
  }

  VolumeOSD {
    id: volumeBox
  }


  BrightnessOSD {
    id: brightnessBox
  }
}
