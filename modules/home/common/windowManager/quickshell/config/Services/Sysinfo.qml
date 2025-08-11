pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: manager

    property string updateInterval: "2s"
    property string cpuUsageStr: ""
    property string cpuTempStr: ""
    property string memoryUsageStr: ""
    property string memoryUsagePerStr: ""
    property real cpuUsage: 0
    property real memoryUsage: 0
    property real cpuTemp: 0
    property real diskUsage: 0
    property real memoryUsagePer: 0
    property string diskUsageStr: ""

    // Timer to periodically update system stats
    Timer {
        interval: {
            let ms = 2000; // Default 2s
            if (updateInterval.endsWith("s")) {
                ms = parseFloat(updateInterval) * 1000;
            } else if (updateInterval.endsWith("ms")) {
                ms = parseFloat(updateInterval);
            }
            return ms;
        }
        running: true
        repeat: true
        onTriggered: updateSystemStats()
    }

    // Process components to read system files
    Process {
        id: procStatProcess
        running: false
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: function (line) {
                if (line.startsWith("cpu ")) {
                    let cpuLine = line.split(/\s+/);
                    let user = parseInt(cpuLine[1]);
                    let nice = parseInt(cpuLine[2]);
                    let system = parseInt(cpuLine[3]);
                    let idle = parseInt(cpuLine[4]);
                    let iowait = parseInt(cpuLine[5]);
                    let irq = parseInt(cpuLine[6]);
                    let softirq = parseInt(cpuLine[7]);

                    let total = user + nice + system + idle + iowait + irq + softirq;
                    let idleTotal = idle + iowait;

                    if (lastCpuTimes.total !== undefined) {
                        let totalDiff = total - lastCpuTimes.total;
                        let idleDiff = idleTotal - lastCpuTimes.idle;
                        cpuUsage = totalDiff > 0 ? ((totalDiff - idleDiff) / totalDiff * 100).toFixed(1) : 0;
                        cpuUsageStr = cpuUsage + "%";
                    }

                    lastCpuTimes = {
                        total: total,
                        idle: idleTotal
                    };
                }
            }
        }
        // onErrorOccurred: function (e) {
        //     console.error("Failed to read /proc/stat:", e);
        // }
    }

    Process {
        id: memInfoProcess
        running: false
        command: ["cat", "/proc/meminfo"]
        stdout: SplitParser {
            onRead: function (line) {
                if (line.startsWith("MemTotal:")) {
                    memTotal = parseInt(line.split(/\s+/)[1]) / 1024 / 1024; // Convert kB to GB
                } else if (line.startsWith("MemAvailable:")) {
                    memAvailable = parseInt(line.split(/\s+/)[1]) / 1024 / 1024; // Convert kB to GB
                }
            }
        }
        // onErrorOccurred: function (e) {
        //     console.error("Failed to read /proc/meminfo:", e);
        // }
    }

    Process {
        id: cpuTempProcess
        running: false
        command: ["cat", "/sys/class/thermal/thermal_zone0/temp"]
        stdout: SplitParser {
            onRead: function (line) {
                let temp = parseInt(line) / 1000; // Temp is in millidegrees Celsius
                cpuTemp = temp.toFixed(1);
                cpuTempStr = cpuTemp + "°C";
            }
        }
        // onErrorOccurred: function (e) {
        //     console.error("Failed to read CPU temp:", e);
        //     cpuTemp = 0;
        //     cpuTempStr = "N/A";
        // }
    }

    Process {
        id: dfProcess
        running: false
        command: ["df", "-h", "--output=used,size,pcent", "/"]
        stdout: SplitParser {
            onRead: function (line) {
                let parts = line.split(/\s+/);
                if (parts.length >= 3 && !line.startsWith("Used")) {
                    diskUsage = parseFloat(parts[2]); // Percentage as a number
                    diskUsageStr = parts[2]; // Includes % sign
                }
            }
        }
        // onErrorOccurred: function (e) {
        //     console.error("Failed to run df:", e);
        //     diskUsage = 0;
        //     diskUsageStr = "N/A";
        // }
    }

    // Variables to track CPU usage calculation
    property var lastCpuTimes: ({})
    property real memTotal: 0
    property real memAvailable: 0

    function updateSystemStats() {
        // Trigger all processes to read data
        procStatProcess.running = true;
        memInfoProcess.running = true;
        cpuTempProcess.running = true;
        dfProcess.running = true;

        // Update memory usage after both memTotal and memAvailable are set
        if (memTotal > 0 && memAvailable > 0) {
            memoryUsage = (memTotal - memAvailable).toFixed(1);
            memoryUsagePer = (memTotal > 0 ? ((memTotal - memAvailable) / memTotal * 100).toFixed(1) : 0);
            memoryUsageStr = memoryUsage + "G";
            memoryUsagePerStr = memoryUsagePer + "%";
        }
    }

    Component.onCompleted: updateSystemStats()
}
