import QtQuick
import Quickshell
import Quickshell.Io
import qs.Components
import qs.Settings

Item {
    id: brightnessDisplay
    property int brightness: -1
    property int previousBrightness: -1
    property var screen: (typeof modelData !== 'undefined' ? modelData : null)
    property string monitorName: screen ? screen.name : "DP-1"  // No se usa con brightnessctl
    property bool isSettingBrightness: false
    property bool hasPendingSet: false
    property int pendingSetValue: -1

    width: pill.width
    height: pill.height

    // Proceso para obtener el brillo actual
    Process {
        id: getBrightnessProcess
        command: ["brightnessctl", "get"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim();
                const rawValue = parseInt(output);
                // brightnessctl devuelve valor absoluto, queremos porcentaje
                const maxValue = brightnessctlMax.value;
                let percentage = 0;

                if (!isNaN(rawValue) && maxValue > 0) {
                    percentage = Math.round((rawValue / maxValue) * 100);
                    percentage = Math.max(0, Math.min(100, percentage));
                }

                if (!isNaN(percentage) && percentage !== previousBrightness) {
                    previousBrightness = brightness;
                    brightness = percentage;
                    pill.text = brightness + "%";
                    pill.show();
                    brightnessTooltip.text = "Brightness: " + brightness + "%";
                }
            }
        }
    }

    // Proceso para obtener el valor máximo de brillo (necesario para calcular porcentaje)
    Process {
        id: brightnessctlMax
        property int value: -1
        command: ["brightnessctl", "max"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim();
                const maxVal = parseInt(output);
                if (!isNaN(maxVal) && maxVal > 0) {
                    brightnessctlMax.value = maxVal;
                    // Refrescar brillo tras tener el máximo
                    getBrightness();
                }
            }
        }
    }

    // Proceso para establecer el brillo
    Process {
        id: setBrightnessProcess
        property int targetValue: -1
        // Establece el brillo en porcentaje: "set 50%"
        command: ["brightnessctl", "set", targetValue + "%"]

        stdout: StdioCollector {
            onStreamFinished: {
                // Aunque no devuelve valor útil, asumimos éxito
                const output = this.text.trim();
                // Podemos ignorar la salida, pero lanzamos get para actualizar
                isSettingBrightness = false;
                getBrightness(); // Actualizamos estado real

                if (hasPendingSet) {
                    hasPendingSet = false;
                    const pendingValue = pendingSetValue;
                    pendingSetValue = -1;
                    setBrightness(pendingValue);
                }
            }
        }

        // onError: {
        //     console.error("Error setting brightness:", errorString);
        //     isSettingBrightness = false;
        //     if (hasPendingSet) {
        //         hasPendingSet = false;
        //         setBrightness(pendingSetValue);
        //     }
        // }
    }

    function getBrightness() {
        if (isSettingBrightness)
            return;
        if (brightnessctlMax.value === -1) {
            brightnessctlMax.running = true; // Esto disparará get después
        } else {
            getBrightnessProcess.running = true;
        }
    }

    function setBrightness(newValue) {
        newValue = Math.max(0, Math.min(100, newValue));

        if (isSettingBrightness) {
            hasPendingSet = true;
            pendingSetValue = newValue;
            return;
        }

        isSettingBrightness = true;
        setBrightnessProcess.targetValue = newValue;
        setBrightnessProcess.running = true;
    }

    PillIndicator {
        id: pill
        icon: "brightness_high"
        text: brightness >= 0 ? brightness + "%" : "--"
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: Theme.textPrimary

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                getBrightness();
                brightnessTooltip.tooltipVisible = true;
            }
            onExited: brightnessTooltip.tooltipVisible = false

            onWheel: function (wheel) {
                const delta = wheel.angleDelta.y > 0 ? 5 : -5;
                const newBrightness = brightness + delta;
                setBrightness(newBrightness);
            }
        }

        StyledTooltip {
            id: brightnessTooltip
            text: "Brightness: " + (brightness >= 0 ? brightness : "--") + "%"
            tooltipVisible: false
            targetItem: pill
            delay: 200
        }
    }

    Component.onCompleted: {
        // Iniciar obteniendo el valor máximo
        brightnessctlMax.running = true;
    }
}
