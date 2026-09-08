// Lock/Lockscreen.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pam
import QtQuick

Item {
    id: root
    property alias locked: lock.locked
    property string wallpaperPath: ""

    Process {
        id: wallpaperQuery
        command: ["sh", "-c", "awww query | grep -oP '(?<=image: ).*' | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: root.wallpaperPath = this.text.trim()
        }
    }

    WlSessionLock {
        id: lock
        onLockedChanged: {
            if (locked) {
                pam.start();
                wallpaperQuery.running = true; // refresh in case wallpaper changed
            }
        }
        WlSessionLockSurface {
            id: surface
            color: "#000000"

            Image {
                anchors.fill: parent
                source: root.wallpaperPath ? "file://" + root.wallpaperPath : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false
                smooth: true
            }

            Rectangle {
                // dim overlay so text/dots stay legible over any wallpaper
                anchors.fill: parent
                color: "#00000066"
            }

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -40
                text: "Locked"
                color: "white"
                font.pixelSize: 28
            }
            // --- This is the part you'll style ---
            Rectangle {
                anchors.centerIn: parent
                color: "transparent"
                border.width: 3
                border.color: "white"
                radius: 69
                height: 30
                width: Math.max(125, dots.width + 40)
                Row {
                    id: dots
                    anchors.centerIn: parent
                    spacing: 4
                    Repeater {
                        model: hiddenInput.text.length
                        delegate: Rectangle {
                            width: 14
                            height: 14
                            radius: 7
                            color: "white"
                        }
                    }
                }
            }
            Text {
                id: errorText
                anchors.top: dots.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#ff6b6b"
                font.pixelSize: 14
            }
            // --- end styled part ---
            TextInput {
                id: hiddenInput
                anchors.fill: parent
                opacity: 0
                focus: true
                echoMode: TextInput.Password
                Component.onCompleted: forceActiveFocus()
                onAccepted: {
                    if (pam.responseRequired) {
                        pam.respond(text);
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: hiddenInput.forceActiveFocus()
            }
        }
    }
    PamContext {
        id: pam
        onCompleted: (result) => {
            if (result === PamResult.Success) {
                lock.locked = false;
                hiddenInput.text = "";
                errorText.text = "";
            } else {
                errorText.text = "Incorrect password";
                hiddenInput.text = "";
                pam.start();
            }
        }
    }
    IpcHandler {
        target: "lock"
        function lock(): void { lock.locked = true }
        function unlock(): void { lock.locked = false }
    }
}
