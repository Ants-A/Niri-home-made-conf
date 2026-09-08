pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property var md3: ({})

  FileView {
    id: colorFile
    path: "/home/ant/.config/quickshell/generated/colors.json"
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      const parsed = JSON.parse(colorFile.text())
      root.md3 = parsed.md3
    }
  }
}
