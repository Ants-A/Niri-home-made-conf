import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import ".."

Rectangle {
  id: card

  // Plain text/data fields, auto-bound from ListModel roles by the view
  // delegate. Only strings/numbers/booleans — no QObjects — are ever stored
  // in ListModel rows (ListModel drops QObject and null role values, which
  // silently broke the summary/body text and delegate creation before).
  required property string summary
  required property string body
  required property string image
  required property int notifId

  // Optional history model. When set, clicking this card removes its entry
  // (found by the plain `notifId` role, which survives ListModel's copy
  // semantics) from that model.
  property var history: null

  // Optional lookup: called at click time with this card's notifId to resolve
  // the *live* notification object (may be null if the notification is gone).
  // Using a callback avoids storing QObjects on the card — such references
  // dangle once the notification closes.
  property var resolveNotif: null

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

  // Clicking a notification invokes its actions and closes it; in the history
  // list it also removes the correct row from the history model.
  function activate() {
    if (card.history) {
      for (let i = 0; i < card.history.count; i++) {
        if (card.history.get(i).notifId === card.notifId) {
          card.history.remove(i, 1)
          break
        }
      }
    }

    if (card.resolveNotif) {
      const notif = card.resolveNotif(card.notifId)
      if (notif) {
        for (const action of (notif.actions || [])) action.invoke()
        notif.dismiss()
      }
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
    source: card.image
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
      text: card.summary
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
      text: card.body
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
}
