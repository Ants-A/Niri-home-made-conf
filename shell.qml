//@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick // for Text
import "./Bar"

ShellRoot {
  id: toplevel

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
}
