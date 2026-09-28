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
  // Notification actions as a JSON string role (ListModel cannot hold arrays,
  // only plain values). Parsed into `actionList` below.
  required property string actions
  // [{identifier, text}] parsed from the `actions` role, never QObjects.
  readonly property var actionList: card.actions === "" ? [] : JSON.parse(card.actions)

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

  implicitHeight: Math.max(icon.height + 20,
                           texts.height + 20 + (actionRow.visible ? actionRow.height + 10 : 0))

  // Removes this card's entry from the history model, found by the plain
  // `notifId` role (survives ListModel's copy semantics).
  function removeRowFromHistory() {
    if (card.history) {
      for (let i = 0; i < card.history.count; i++) {
        if (card.history.get(i).notifId === card.notifId) {
          card.history.remove(i, 1)
          break
        }
      }
    }
  }

  // Clicking the card body dismisses the notification (and removes the
  // history row). Actions are deliberately NOT invoked here — that would fire
  // every action at once (e.g. Pair *and* Decline). Use the action buttons.
  function activate() {
    card.removeRowFromHistory()
    if (card.resolveNotif) {
      const notif = card.resolveNotif(card.notifId)
      if (notif) notif.dismiss()
    }
  }

  // A specific action button was clicked: invoke only that action, then
  // dismiss (falls back to just removing the history row if the live
  // notification is already gone).
  function invokeAction(identifier) {
    card.removeRowFromHistory()
    if (card.resolveNotif) {
      const notif = card.resolveNotif(card.notifId)
      if (notif) {
        for (const action of (notif.actions || [])) {
          if (action.identifier === identifier) {
            action.invoke()
            break
          }
        }
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
    objectName: "cardMouseArea"
    anchors.fill: parent
    onClicked: card.activate()
  }

  // Action buttons, laid out below the text column. Declared after the
  // full-card MouseArea so each button's MouseArea receives clicks first.
  Row {
    id: actionRow
    objectName: "actionRow"
    visible: card.actionList.length > 0
    x: card.textX
    y: texts.y + texts.height + 10
    spacing: 8

    Repeater {
      model: card.actionList

      delegate: Rectangle {
        objectName: "actionButton"
        height: 28
        radius: 7
        color: Colors.md3.primary
        width: Math.min(actionLabel.implicitWidth + 24, 160)

        Text {
          id: actionLabel
          anchors.centerIn: parent
          text: modelData.text
          color: Colors.md3.on_primary
          font.pixelSize: 14
          elide: Text.ElideRight
          width: Math.min(implicitWidth, parent.width - 24)
        }

        MouseArea {
          anchors.fill: parent
          onClicked: card.invokeAction(modelData.identifier)
        }
      }
    }
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
