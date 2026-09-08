import QtQuick
import Quickshell
import Quickshell.Io

// Runs bin/just-hyprtonation for as long as the plugin is enabled. The player is a
// separate process (fluidsynth needs one); this file only keeps it alive. Disabling the
// plugin destroys this object, which ends the process; a crash restarts it after a pause
// that grows while it keeps failing (fluidsynth or the SoundFont missing, for example).
Item {
  id: root

  property var shell: null
  property string omarchyPath: Quickshell.env("OMARCHY_PATH")

  readonly property string player: Qt.resolvedUrl("../bin/just-hyprtonation").toString().replace(/^file:\/\//, "")
  property int failures: 0

  Process {
    id: proc
    command: ["/usr/bin/python3", root.player]
    running: true
    stderr: StdioCollector {
      onStreamFinished: if (text.trim()) console.warn("just-hyprtonation: " + text.trim())
    }
    onExited: (code, status) => {
      root.failures = code === 0 ? 0 : root.failures + 1
      restart.interval = Math.min(60000, 2000 * Math.pow(2, Math.max(0, root.failures - 1)))
      restart.start()
    }
  }

  Timer {
    id: restart
    repeat: false
    onTriggered: if (!proc.running) proc.running = true
  }

  // A clean exit (the `stop` subcommand) restarts too, after 2 s: while the plugin is
  // enabled the player is meant to be running. Disable the plugin to silence it, or use
  // `mute`.
}
