import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// Settings pane: instrument, F-key layout, mute. Lives at the repo root: as shell/Panel.qml the
// shell's panel loader refused it with "File name case mismatch" (cause not established). Summoned with
//   omarchy-shell shell toggle person1873.just-hyprtonation
// Reads the player's remembered choices from ~/.local/state/just-hyprtonation and
// applies changes through bin/just-hyprtonation, the same way the CLI does.
Item {
  id: root

  property var shell: null
  property var manifest: null
  property bool opened: false

  readonly property string player: Qt.resolvedUrl("bin/just-hyprtonation").toString().replace(/^file:\/\//, "")
  readonly property string stateDir: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/just-hyprtonation"
  readonly property string runDir: Quickshell.env("XDG_RUNTIME_DIR") + "/just-hyprtonation"
  readonly property var instruments: [
    ["vibraphone", "Vibraphone"], ["cello", "Cello"], ["glass", "Glass"], ["organ", "Organ"],
    ["saw", "Saw"], ["dulcimer", "Dulcimer"], ["tubular", "Tubular bells"], ["handbell", "Handbells"]
  ]

  property string instrument: ""
  property string layout: "piano"
  property int cursor: -1          // keyboard cursor over the instrument rows
  property bool running: false
  property bool muted: false
  readonly property string fontFamily: Style.font.family

  function open(payloadJson) {
    instrumentFile.reload()
    layoutFile.reload()
    pidFile.reload()
    root.opened = true
    root.cursor = -1
    Qt.callLater(function() { if (root.opened) keyCatcher.forceActiveFocus() })
  }

  function close() { root.opened = false }

  function dismiss() {
    if (root.shell && typeof root.shell.hide === "function")
      root.shell.hide((root.manifest && root.manifest.id) || "person1873.just-hyprtonation")
    else close()
  }

  function run(args) {
    if (cmd.running) return
    cmd.command = ["/usr/bin/python3", root.player].concat(args)
    cmd.running = true
  }

  function setInstrument(name) {
    if (name === root.instrument) return
    root.instrument = name          // optimistic; the file watch confirms
    run(["instrument", name])
  }

  function setLayout(name) {
    if (name === root.layout) return
    root.layout = name
    run(["layout", name])
  }

  function toggleMute() {
    root.muted = !root.muted        // the player keeps no mute file; tracked here per session
    run(["mute"])
  }

  Process { id: cmd; command: ["true"] }

  // The player writes these on start and on every change; watching them keeps the pane
  // honest when the change came from the menu, the key, or the CLI.
  FileView {
    id: instrumentFile
    path: root.stateDir + "/instrument"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.instrument = String(text() || "").trim()
    onLoadFailed: root.instrument = ""
  }
  FileView {
    id: layoutFile
    path: root.stateDir + "/layout"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.layout = String(text() || "").trim() || "piano"
    onLoadFailed: root.layout = "piano"
  }
  FileView {
    id: pidFile
    path: root.runDir + "/pid"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: root.running = String(text() || "").trim() !== ""
    onLoadFailed: root.running = false
  }

  PanelWindow {
    id: win
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "just-hyprtonation"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Rectangle {
      anchors.fill: parent
      color: Qt.rgba(0, 0, 0, 0.45)
      MouseArea { anchors.fill: parent; onClicked: root.dismiss() }
    }

    Item {
      id: keyCatcher
      anchors.fill: parent
      focus: true
      Keys.onEscapePressed: root.dismiss()
      // Up/Down walk the instruments, Return picks, L flips the layout, M mutes.
      Keys.onPressed: function(event) {
        var n = root.instruments.length
        if (event.key === Qt.Key_Down || event.key === Qt.Key_J) { root.cursor = (root.cursor + 1) % n; event.accepted = true }
        else if (event.key === Qt.Key_Up || event.key === Qt.Key_K) { root.cursor = (root.cursor - 1 + n) % n; event.accepted = true }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
          if (root.cursor >= 0) root.setInstrument(root.instruments[root.cursor][0])
          event.accepted = true
        }
        else if (event.key === Qt.Key_L) { root.setLayout(root.layout === "laptop" ? "piano" : "laptop"); event.accepted = true }
        else if (event.key === Qt.Key_M) { if (root.running) root.toggleMute(); event.accepted = true }
      }

      Rectangle {
        id: card
        anchors.centerIn: parent
        width: Style.space(360)
        height: content.implicitHeight + Style.space(40)
        radius: Style.cornerRadius
        color: Color.popups.background
        border.color: Color.popups.border
        border.width: Math.max(1, Style.normalBorderWidth)

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
          id: content
          anchors.fill: parent
          anchors.margins: Style.space(20)
          spacing: Style.space(12)

          RowLayout {
            Layout.fillWidth: true
            spacing: Style.space(12)
            Column {
              Layout.fillWidth: true
              spacing: Style.space(2)
              Text {
                text: "Just hyprtonation"
                color: Color.popups.text
                font.family: root.fontFamily
                font.pixelSize: Style.font.title
                font.bold: true
              }
              Text {
                text: root.running ? (root.muted ? "MUTED" : "PLAYING") : "NOT RUNNING"
                color: Qt.darker(Color.popups.text, 1.4)
                font.family: root.fontFamily
                font.pixelSize: Style.font.caption
                font.bold: true
                font.letterSpacing: 1.2
              }
            }
            ToggleSwitch {
              checked: root.running && !root.muted
              interactive: root.running
              foreground: Color.popups.text
              onToggled: root.toggleMute()
            }
          }

          PanelSeparator { Layout.fillWidth: true; foreground: Color.popups.text }

          PanelSectionHeader { text: "INSTRUMENT"; foreground: Color.popups.text; fontFamily: root.fontFamily }

          Column {
            Layout.fillWidth: true
            spacing: Style.space(2)
            Repeater {
              model: root.instruments
              Rectangle {
                required property var modelData
                required property int index
                readonly property bool selected: modelData[0] === root.instrument
                readonly property bool hot: rowMouse.containsMouse || root.cursor === index
                width: parent.width
                height: Style.spacing.controlHeight
                radius: Style.cornerRadius
                color: selected ? Style.selectedFill : (hot ? Style.hoverFill : "transparent")
                border.width: root.cursor === index ? Math.max(1, Style.hoverBorderWidth) : 0
                border.color: Style.hoverBorderColor
                Text {
                  anchors.left: parent.left
                  anchors.leftMargin: Style.spacing.controlPaddingX
                  anchors.verticalCenter: parent.verticalCenter
                  text: modelData[1]
                  color: Color.popups.text
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.body
                }
                Text {
                  anchors.right: parent.right
                  anchors.rightMargin: Style.spacing.controlPaddingX
                  anchors.verticalCenter: parent.verticalCenter
                  visible: parent.selected
                  text: "✓"
                  color: Color.accent
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.body
                }
                MouseArea {
                  id: rowMouse
                  anchors.fill: parent
                  hoverEnabled: true
                  onClicked: root.setInstrument(parent.modelData[0])
                  onContainsMouseChanged: if (containsMouse) root.cursor = parent.index
                }
              }
            }
          }

          PanelSeparator { Layout.fillWidth: true; foreground: Color.popups.text }

          PanelSectionHeader { text: "F-KEY LAYOUT"; foreground: Color.popups.text; fontFamily: root.fontFamily }

          ButtonGroup {
            Layout.fillWidth: true
            options: [{ label: "Piano", value: "piano" }, { label: "Laptop", value: "laptop" }]
            value: root.layout
            foreground: Color.popups.text
            background: Color.popups.background
            onChanged: function(v) { root.setLayout(v) }
          }

          Text {
            Layout.fillWidth: true
            text: root.layout === "laptop"
              ? "F-keys as they sit above the digits; F1..F7 a just major scale on the sharpened tonic."
              : "The twelve sharps in order."
            color: Qt.darker(Color.popups.text, 1.4)
            font.family: root.fontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
          }
        }
      }
    }
  }
}
