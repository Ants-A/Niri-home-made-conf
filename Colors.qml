pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property var md3: ({})
  property var palette: ({})  
  property var base16: ({})


  FileView {
    id: colorFile
    path: "/home/ant/.config/quickshell/generated/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      const parsed = JSON.parse(colorFile.text())
      root.md3 = parsed.md3
      root.palette = parsed.palette
      root.base16 = parsed.base16
    }
  }
}
