// Modified from https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/services/Brightness.qml
// From https://github.com/caelestia-dots/shell with modifications.
// License: GPLv3

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

/**
 * For managing brightness of monitors. Supports both brightnessctl and ddcutil.
 */
Singleton {
    id: root
    signal brightnessChanged

    property var ddcMonitors: []
    readonly property list<BrightnessMonitor> monitors: Quickshell.screens.map(screen => monitorComp.createObject(root, {
            screen
        }))

    function getMonitorForScreen(screen: ShellScreen): var {
        return monitors.find(m => m.screen === screen);
    }

    function increaseBrightness(): void {
        const focusedName = Hyprland.focusedMonitor.name;
        const monitor = monitors.find(m => focusedName === m.screen.name);
        if (monitor)
            monitor.setBrightness(monitor.brightness + 0.05);
    }

    function decreaseBrightness(): void {
        const focusedName = Hyprland.focusedMonitor.name;
        const monitor = monitors.find(m => focusedName === m.screen.name);
        if (monitor && monitor.brightness > 0)
            monitor.setBrightness(monitor.brightness - 0.05);
    }

    reloadableId: "brightness"

    onMonitorsChanged: {
        ddcMonitors = [];
        ddcProc.running = true;
    }

    function initializeMonitor(i: int): void {
        if (i >= monitors.length)
            return;
        monitors[i].initialize();
    }

    function ddcDetectFinished(): void {
        initializeMonitor(0);
    }

    readonly property string backlightLookupScript: `
        screen="$1"
        match=""
        for connector in /sys/class/drm/card*-"$screen"; do
            [ -e "$connector" ] || continue
            connector_path=$(readlink -f "$connector") || continue
            for backlight in /sys/class/backlight/*; do
                [ -e "$backlight/brightness" ] || continue
                backlight_path=$(readlink -f "$backlight/device") || continue
                if [ "$connector_path" = "$backlight_path" ]; then
                    [ -z "$match" ] || exit 2
                    match="$backlight"
                fi
            done
        done
        [ -n "$match" ] || exit 1
        printf '%s|%s\\n' "$match/brightness" "$(cat "$match/max_brightness")"
    `

    Process {
        id: ddcProc

        command: ["ddcutil", "detect", "--brief"]
        stdout: SplitParser {
            splitMarker: "\n\n"
            onRead: data => {
                if (data.startsWith("Display ")) {
                    const lines = data.split("\n").map(l => l.trim());
                    root.ddcMonitors.push({
                        name: lines.find(l => l.startsWith("DRM connector:")).split("-").slice(1).join('-'),
                        busNum: lines.find(l => l.startsWith("I2C bus:")).split("/dev/i2c-")[1]
                    });
                }
            }
        }
        onExited: root.ddcDetectFinished()
    }

    Process {
        id: setProc
    }

    component BrightnessMonitor: QtObject {
        id: monitor

        required property ShellScreen screen
        property bool isDdc
        property string busNum
        property string sysfsPath: ""
        property string sysfsDevice: ""
        property int rawMaxBrightness: 100
        property real brightness
        property bool ready: false
        property bool updatingFromSysfs: false

        onBrightnessChanged: {
            if (!monitor.ready)
                return;
            root.brightnessChanged();
            if (monitor.updatingFromSysfs)
                return;
            if (monitor.isDdc)
                setTimer.restart();
            else
                syncBrightness();
        }

        function initialize() {
            monitor.ready = false;
            const match = root.ddcMonitors.find(m => m.name === screen.name && !root.monitors.slice(0, root.monitors.indexOf(this)).some(mon => mon.busNum === m.busNum));
            isDdc = !!match;
            busNum = match?.busNum ?? "";
            if (isDdc) {
                initProc.command = ["ddcutil", "-b", busNum, "getvcp", "10", "--brief"];
                initProc.running = true;
            } else {
                sysfsProc.command = ["sh", "-c", root.backlightLookupScript, "brightness-lookup", screen.name];
                sysfsProc.running = true;
            }
        }

        function updateFromSysfs(): void {
            const rawValue = Number(brightnessFile.text().trim());
            if (!Number.isFinite(rawValue) || monitor.rawMaxBrightness <= 0) {
                console.warn(`Invalid backlight value for ${monitor.screen.name}`);
                return;
            }

            const value = Math.max(0, Math.min(1, rawValue / monitor.rawMaxBrightness));
            if (monitor.ready && Math.abs(value - monitor.brightness) < 0.0001)
                return;

            monitor.updatingFromSysfs = true;
            monitor.brightness = value;
            monitor.updatingFromSysfs = false;
            monitor.ready = true;
        }

        readonly property Process initProc: Process {
            stdout: SplitParser {
                onRead: data => {
                    const [, , , current, max] = data.split(" ");
                    monitor.rawMaxBrightness = parseInt(max);
                    monitor.brightness = parseInt(current) / monitor.rawMaxBrightness;
                    monitor.ready = true;
                }
            }
            onExited: (exitCode, exitStatus) => {
                initializeMonitor(root.monitors.indexOf(monitor) + 1);
            }
        }

        readonly property Process sysfsProc: Process {
            stdout: SplitParser {
                onRead: data => {
                    const [path, max] = data.trim().split("|");
                    const parsedMax = Number(max);
                    if (!path || !Number.isFinite(parsedMax) || parsedMax <= 0) {
                        console.warn(`Could not resolve a backlight device for ${monitor.screen.name}`);
                        return;
                    }

                    monitor.sysfsPath = path;
                    const pathParts = path.split("/");
                    monitor.sysfsDevice = pathParts[pathParts.length - 2];
                    monitor.rawMaxBrightness = parsedMax;
                }
            }
            onExited: (exitCode, exitStatus) => {
                if (exitCode !== 0)
                    console.warn(`Backlight lookup failed for ${monitor.screen.name} (exit ${exitCode})`);
                initializeMonitor(root.monitors.indexOf(monitor) + 1);
            }
        }

        readonly property FileView brightnessFile: FileView {
            path: monitor.sysfsPath
            watchChanges: true
            onFileChanged: reload()
            onLoaded: monitor.updateFromSysfs()
        }

        // We need a delay for DDC monitors because they can be quite slow and might act weird with rapid changes
        property var setTimer: Timer {
            id: setTimer
            interval: monitor.isDdc ? 300 : 0
            onTriggered: {
                syncBrightness();
            }
        }

        function syncBrightness() {
            const brightnessValue = Math.max(monitor.brightness, 0);
            if (isDdc) {
                const rawValueRounded = Math.max(Math.floor(brightnessValue * monitor.rawMaxBrightness), 1);
                setProc.exec(["ddcutil", "-b", busNum, "setvcp", "10", rawValueRounded]);
            } else {
                const valuePercentNumber = Math.floor(brightnessValue * 100);
                let valuePercent = `${valuePercentNumber}%`;
                if (valuePercentNumber == 0)
                    valuePercent = "1"; // Prevent fully black
                setProc.exec(["brightnessctl", "--device", monitor.sysfsDevice, "s", valuePercent, "--quiet"]);
            }
        }

        function setBrightness(value: real): void {
            if (!monitor.ready)
                return;
            value = Math.max(0, Math.min(1, value));
            monitor.brightness = value;
        }
    }

    Component {
        id: monitorComp

        BrightnessMonitor {}
    }


    // External trigger points

    IpcHandler {
        target: "brightness"

        function increment() {
            onPressed: root.increaseBrightness();
        }

        function decrement() {
            onPressed: root.decreaseBrightness();
        }
    }

    GlobalShortcut {
        name: "brightnessIncrease"
        description: "Increase brightness"
        onPressed: root.increaseBrightness()
    }

    GlobalShortcut {
        name: "brightnessDecrease"
        description: "Decrease brightness"
        onPressed: root.decreaseBrightness()
    }
}
