import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    property color colBg: "#1a1b26"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property string fontFamily: "Mononoki Nerd Font"
    property int fontSize: 18

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    property int memUsage: 0

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: "#1a1b26"

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
                var used = parseInt(parts[2]) || 0;
                memUsage = Math.round(100 * used / total);
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
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8

        Repeater {
            model: 9

            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                text: index + 1
                color: isActive ? "#0db9d7" : (ws ? "#7aa2f7" : "#444b6a")
                font {
                    pixelSize: 14
                    bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            id: clock
            text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            color: root.colBlue

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

        Text {
            text: "CPU: " + cpuUsage + "%"
            color: root.colYellow
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
        }

        Rectangle {
            width: 1
            height: 16
            color: root.colBlue
        }

        Text {
            text: "RAM: " + memUsage + "%"
            color: root.colYellow
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
        }
    }
}
