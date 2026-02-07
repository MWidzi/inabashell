import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Window
import QtQuick.Layouts

PanelWindow {
    id: root

    property color colBg: "#1a1b26"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"

    // visual variables
    property string fontFamily: "Mononoki Nerd Font"
    property int fontSize: 18

    property color mchr0: "#000000"
    property color mchr1: "#454545"
    property color mchr2: "#858585"
    property color mchr3: "#c7c7c7"
    property color mchr4: "#e1e1e1"
    property color mchr5: "#f3f3f3"

    property color accent1: "#F5959F"
    property color accent2: "#E95274"
    property color accent3: "#E84F56"
    property color accent4: "#F5959F"
    property color accent5: "#C4C9FC"
    property color accent6: "#8FB6E8"
    property color accent7: "#F4D177"
    property color accent8: "#F6DE29"

    property color bg: "#e6343434"
    property color fg: "#b2b2b2"

    // variables
    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    property real memUsage: 0
    property real maxMem: 0

    property int cpuTemp: 0
    property string getCpuTempIcon: {
        var iconStat = Math.floor(root.cpuTemp / 20);
        var icons = ["", "", "", "", ""];
        return icons[Math.min(iconStat, 4)] || "–";
    }

    property string playerIcon: ""
    property string playingIndicator: ""
    property string artist: ""
    property string cachedArtist: ""
    property bool hasPlayerctlOutput: false

    property int volume: 0
    property bool muted: false
    property string getVolumeIcon: {
        if (!(root.volume > 0)) {
            return "";
        }
        if (root.muted) {
            return "";
        }

        var iconStat = Math.floor(root.volume / 33);
        var icons = ["", "", ""];
        return icons[Math.min(iconStat, 2)] || "–";
    }

    property string wifiIcon: ""

    // basic bar setup
    implicitHeight: Screen.height * 0.04
    anchors.top: true
    anchors.left: true
    anchors.right: true
    margins {
        left: Screen.width * 0.2
        right: Screen.width * 0.2
    }

    color: "transparent"

    Rectangle {
        anchors.fill: parent

        bottomLeftRadius: 20
        bottomRightRadius: 20

        color: root.bg

        Process {
            id: cpuProc
            command: ["sh", "-c", "head -1 /proc/stat"]

            stdout: SplitParser {
                onRead: data => {
                    if (!data)
                        return;
                    var p = data.trim().split(/\s+/);
                    var idle = parseInt(p[4]) + parseInt(p[5]);
                    var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                    if (lastCpuTotal > 0) {
                        cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
                    }
                    lastCpuTotal = total;
                    lastCpuIdle = idle;
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: memProc
            command: ["sh", "-c", "free | grep Mem"]
            stdout: SplitParser {
                onRead: data => {
                    var parts = data.trim().split(/\s+/);
                    var total = parseInt(parts[1]) || 1;
                    var used = parseFloat(parts[2]) || 0;
                    memUsage = (used / 1000000).toFixed(1);
                    maxMem = (total / 1000000).toFixed(1);
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: tempProc
            command: ["sh", "-c", "paste <(cat /sys/class/thermal/thermal_zone*/type) <(cat /sys/class/thermal/thermal_zone*/temp) | grep 'x86'"]
            stdout: SplitParser {
                onRead: data => {
                    var parts = data.trim().split(/\s+/);
                    var temp = parseInt(parts[1]) || 0;
                    root.cpuTemp = (temp / 1000);
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: playerctlProc
            command: ["sh", "-c", "~/.config/scripts/get-song.sh wb"]
            stdout: SplitParser {
                onRead: data => {
                    if (data.includes("No players found")) {
                        root.playerIcon = "";
                        root.playingIndicator = "";
                        root.artist = "";
                        root.cachedArtist = "";
                        root.hasPlayerctlOutput = false;
                        return;
                    }
                    var parts = data.trim().split(/\s+/);
                    root.playerIcon = parts[0] || "";
                    root.playingIndicator = parts[1] || "";
                    root.hasPlayerctlOutput = true;

                    var artistName = "";
                    for (let i = 2; i < parts.length; i++) {
                        artistName += (i > 2 ? " " : "") + parts[i];
                    }
                    root.artist = artistName;
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: volumeProc
            command: ["sh", "-c", "awk -F\"[][]\" '/Left:/ { print $2, $4 }' <(amixer sget Master)"]
            stdout: SplitParser {
                onRead: data => {
                    var parts = data.trim().split(/\s+/);

                    if (parts[1] == "on") {
                        root.muted = false;
                        root.volume = parseInt(parts[0]);
                    } else {
                        root.muted = true;
                    }
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: networkProc
            command: ["sh", "-c", "~/.config/scripts/network_strength.sh"]
            stdout: SplitParser {
                onRead: data => {
                    root.wifiIcon = data;
                }
            }

            Component.onCompleted: running = true
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                cpuProc.running = true;
                memProc.running = true;
                tempProc.running = true;
                playerctlProc.running = true;
                networkProc.running = true;
            }
        }

        Timer {
            interval: 200
            running: true
            repeat: true
            onTriggered: {
                volumeProc.running = true;
            }
        }

        // WORKSPACES
        RowLayout {
            anchors.fill: parent
            anchors.margins: 8

            RowLayout {
                spacing: 10

                RowLayout {
                    spacing: 2

                    Repeater {
                        model: 6

                        Text {
                            id: wsText

                            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                            property bool hovered: mouseArea.containsMouse

                            text: index + 1

                            property color baseColor: (ws ? root.mchr3 : root.mchr2)
                            color: hovered ? root.mchr5 : baseColor

                            font {
                                family: root.fontFamily
                                pixelSize: hovered ? root.fontSize + 4 : root.fontSize
                                bold: true
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: () => {
                                    hovered = false;
                                    Hyprland.dispatch("workspace " + (index + 1));
                                }
                            }

                            states: [
                                State {
                                    name: "hovered"
                                    when: hovered
                                    PropertyChanges {
                                        target: wsText
                                        font.pixelSize: root.fontSize + 4
                                        color: root.mchr5
                                    }
                                },
                                State {
                                    name: "active"
                                    when: isActive
                                    PropertyChanges {
                                        target: wsText
                                        color: root.accent5
                                    }
                                },
                                State {
                                    name: "normal"
                                    when: !hovered
                                    PropertyChanges {
                                        target: wsText
                                        font.pixelSize: root.fontSize
                                        color: baseColor
                                    }
                                }
                            ]

                            transitions: [
                                Transition {
                                    to: "hovered"
                                    ColorAnimation {
                                        target: wsText
                                        property: "color"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                    NumberAnimation {
                                        target: wsText
                                        property: "font.pixelSize"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                },
                                Transition {
                                    to: "active"
                                    ColorAnimation {
                                        target: wsText
                                        property: "color"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                },
                                Transition {
                                    to: "normal"
                                    ColorAnimation {
                                        target: wsText
                                        property: "color"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                    NumberAnimation {
                                        target: wsText
                                        property: "font.pixelSize"
                                        duration: 200
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            ]
                        }
                    }
                }

                Rectangle {
                    width: 2
                    height: 16
                    color: root.hasPlayerctlOutput ? root.mchr2 : "transparent"
                }

                // playerctl
                RowLayout {
                    spacing: 20

                    RowLayout {
                        spacing: 3

                        Text {
                            text: root.playerIcon

                            color: root.playerIcon == "" ? root.accent5 : (root.playerIcon == "󰈹" ? root.accent3 : root.mchr5)
                            font {
                                family: root.fontFamily
                                pixelSize: root.fontSize
                                bold: true
                            }
                        }

                        Text {
                            text: root.artist
                            color: root.fg
                            font {
                                family: root.fontFamily
                                pixelSize: root.fontSize
                                bold: true
                            }
                        }
                    }

                    Text {
                        text: root.playingIndicator

                        color: root.mchr5
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            // CLOCK
            Text {
                id: clock
                text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                color: root.fg

                anchors.centerIn: parent

                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                }
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 15

                RowLayout {
                    // CPU
                    Text {
                        text: ""
                        color: root.mchr5
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    Text {
                        text: cpuUsage + "%"
                        color: cpuUsage > 50 ? root.accent7 : (cpuUsage > 80 ? root.accent3 : root.mchr3)
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    // spacer
                    Rectangle {
                        width: 2
                        height: 16
                        color: root.mchr2
                    }

                    // TEMP
                    Text {
                        text: root.getCpuTempIcon
                        color: root.mchr5
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    Text {
                        text: cpuTemp + "°"
                        color: cpuTemp > 40 ? root.accent7 : cpuTemp > 80 ? root.accent3 : root.mchr3
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    // spacer
                    Rectangle {
                        width: 2
                        height: 16
                        color: root.mchr2
                    }

                    // RAM
                    Text {
                        text: ""

                        color: root.mchr5
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    Text {
                        text: memUsage + " GB"
                        color: Math.round(100 * (memUsage / maxMem)) > 50 ? root.accent7 : (Math.round(100 * (memUsage / maxMem)) > 80 ? root.accent3 : root.mchr3)
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }
                }

                // spacer
                Rectangle {
                    width: 2
                    height: 16
                    color: root.mchr2
                }

                // VOLUME
                RowLayout {
                    spacing: 2

                    Text {
                        text: root.getVolumeIcon
                        color: root.muted ? root.accent2 : root.mchr5
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }

                    Text {
                        text: root.muted ? "MUTE" : root.volume + "%"
                        color: root.muted ? root.accent2 : root.fg
                        font {
                            family: root.fontFamily
                            pixelSize: root.fontSize
                            bold: true
                        }
                    }
                }

                // spacer
                Rectangle {
                    width: 2
                    height: 16
                    color: root.mchr2
                }

                Text {
                    text: root.wifiIcon
                    color: root.mchr5
                    font {
                        family: root.fontFamily
                        pixelSize: root.fontSize
                        bold: true
                    }
                }
            }
        }
    }
}
