import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import ".."

Rectangle {
  id: card

  // The Notification object this card represents.
  // Auto-bound from the ListModel "notification" role by the view delegate.
  required property var notification

  // Optional history model. When set, clicking this card removes its entry
  // from that model (used for the history panel in the center control).
  property var history: null

  // Whether the card should close itself after a few seconds.
  // Only the popup toasts set this to true; history cards never auto-expire.
  property bool autoExpire: false

  implicitWidth: 400
  radius: 12
  color: "#80000000"
  border.width: 3
  border.color: Colors.md3.primary

  // Left edge of the text column (moves right when an icon is shown).
  readonly property real textX: icon.visible ? 10 + icon.width + 10 : 10
  // The text column gets an explicit width so wrapMode + maximumLineCount
  // produce a deterministic laid-out height (implicit heights of wrapped
  // Text do not, which is why the card previously collapsed to 84px).
  readonly property real textWidth: implicitWidth - textX - 10

  implicitHeight: Math.max(icon.height + 20, texts.height + 20)

  // Clicking a notification invokes its actions and closes it. In the history
  // list it also removes the correct row (found by the plain `id` role, which
  // survives ListModel's copy semantics; object identity does not) from the
  // history model.
  function activate() {
    if (card.history && card.notification) {
      for (let i = 0; i < card.history.count; i++) {
        if (card.history.get(i).id === card.notification.id) {
          card.history.remove(i, 1)
          break
        }
      }
    }

    if (card.notification) {
      for (const action of (card.notification.actions || [])) action.invoke()
      card.notification.dismiss()
    }
  }

  Image {
    id: icon
    x: 10
    y: 10
    width: 36
    height: 36
    fillMode: Image.PreserveAspectFit
    mipmap: true
    source: card.notification ? (card.notification.image || card.notification.appIcon || "") : ""
    visible: source.toString() !== ""
  }

  Column {
    id: texts
    x: card.textX
    y: 10
    width: card.textWidth
    spacing: 4

    Text {
      id: summaryText
      width: parent.width
      text: card.notification ? card.notification.summary : ""
      color: "white"
      font.bold: true
      font.pixelSize: 18
      wrapMode: Text.Wrap
      maximumLineCount: 2
      elide: Text.ElideRight
    }

    Text {
      id: bodyText
      width: parent.width
      text: card.notification ? card.notification.body : ""
      visible: text !== ""
      color: "white"
      font.pixelSize: 14
      wrapMode: Text.Wrap
      maximumLineCount: 4
      elide: Text.ElideRight
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: card.activate()
  }

  // Entrance fade, driven from the delegate so it isn't restarted by view
  // re-layouts (a ListView `add` Transition's opacity animation stalled near 0
  // when new toasts arrived while earlier ones were still fading in).
  Component.onCompleted: {
    card.opacity = 0
    fadeIn.start()
  }

  NumberAnimation {
    id: fadeIn
    target: card
    property: "opacity"
    from: 0
    to: 1
    duration: 200
    running: false
  }

  Timer {
    id: expireTimer
    interval: 5000
    running: false
    repeat: false
    onTriggered: {
      if (card.notification) card.notification.expire()
    }
  }

  onAutoExpireChanged: {
    if (card.autoExpire) expireTimer.restart()
  }
  onNotificationChanged: {
    if (card.autoExpire) expireTimer.restart()
  }
}