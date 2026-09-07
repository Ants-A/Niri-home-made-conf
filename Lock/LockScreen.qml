// Lock/Lockscreen.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pam
import QtQuick

Item {
    id: root
    property alias locked: lock.locked

    WlSessionLock {
        id: lock

        onLockedChanged: {
            if (locked) {
                pam.start();
            }
        }

        WlSessionLockSurface {
            id: surface

            Rectangle {
                anchors.fill: parent
                color: "#111111"

                Text {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -40
                    text: "Locked"
                    color: "white"
                    font.pixelSize: 28
                }

                // --- This is the part you'll style ---
                // A fake password field driven entirely by hiddenInput.text.
                // Replace this Row with whatever visual you want: dots,
                // a styled Rectangle border, an animation, etc.
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

                // The real, functional input. Invisible, but focused and
                // receiving all keystrokes.
                TextInput {
                    id: hiddenInput
                    anchors.fill: parent // covers the surface so it's easy to click-to-focus
                    opacity: 0
                    focus: true
                    echoMode: TextInput.Password // extra safety even though it's invisible
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
                pam.start(); // allow another attempt
            }
        }
    }

    IpcHandler {
        target: "lock"
        function lock(): void { lock.locked = true }
        function unlock(): void { lock.locked = false }
    }
}
