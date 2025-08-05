// Theme.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Settings

Singleton {
    id: root

    function applyOpacity(color, opacity) {
        return color.replace("#", "#" + opacity);
    }

    // FileView to load theme data from JSON file
    FileView {
        id: themeFile
        // path: Settings.settingsDir + "Theme.json"
        // watchChanges: true
        // onFileChanged: reload()
        // onAdapterUpdated: writeAdapter()
        // onLoadFailed: function (error) {
        //     if (error.includes("No such file")) {
        //         themeData = {};
        //         writeAdapter();
        //     }
        // }
        JsonAdapter {
            id: themeData

            // Backgrounds
            property string backgroundPrimary: "#000000"//"#0C0D11"
            property string backgroundSecondary: "#1A1A1A"//"151720"
            property string backgroundTertiary: "#1F1F1F"//"#1D202B"

            // Surfaces & Elevation
            property string surface: "#2B2B2B"//"#1A1C26"
            property string surfaceVariant: "#2B2B2B"//"#2A2D3A"

            // Text Colors
            property string textPrimary: "#C7C7C7"//"#CACEE2"
            property string textSecondary: "#C0C0C0"//"#B7BBD0"
            property string textDisabled: "#D0D0D0"//"#6B718A"

            // Accent Colors
            property string accentPrimary: "#C7C7C7"//"#A8AEFF"
            property string accentSecondary: "#C0C0C0"//"#9EA0FF"
            property string accentTertiary: "#D0D0D0"//"#8EABFF"

            // Error/Warning
            property string error: "#FF4040"//"#FF6B81"
            property string warning: "#D02060"//"#FFBB66"

            // Highlights & Focus
            property string highlight: "#20A0E0"//"#E3C2FF"
            property string rippleEffect: "#40C0FF"//"#F3DEFF"

            // Additional Theme Properties
            property string onAccent: "#1A1A1A"//"#1A1A1A"
            property string outline: "#2B2B2B"//"#44485A"

            // Shadows & Overlays
            property string shadow: "#1F1F1F"//"000000"
            property string overlay: "#1F1F1F"//"#11121A"
        }
    }

    // Backgrounds
    property color backgroundPrimary: themeData.backgroundPrimary
    property color backgroundSecondary: themeData.backgroundSecondary
    property color backgroundTertiary: themeData.backgroundTertiary

    // Surfaces & Elevation
    property color surface: themeData.surface
    property color surfaceVariant: themeData.surfaceVariant

    // Text Colors
    property color textPrimary: themeData.textPrimary
    property color textSecondary: themeData.textSecondary
    property color textDisabled: themeData.textDisabled

    // Accent Colors
    property color accentPrimary: themeData.accentPrimary
    property color accentSecondary: themeData.accentSecondary
    property color accentTertiary: themeData.accentTertiary

    // Error/Warning
    property color error: themeData.error
    property color warning: themeData.warning

    // Highlights & Focus
    property color highlight: themeData.highlight
    property color rippleEffect: themeData.rippleEffect

    // Additional Theme Properties
    property color onAccent: themeData.onAccent
    property color outline: themeData.outline

    // Shadows & Overlays
    property color shadow: applyOpacity(themeData.shadow, "B3")
    property color overlay: applyOpacity(themeData.overlay, "66")

    // Font Properties
    property string fontFamily: "Roboto"         // Family for all text

    // Font size multiplier - adjust this in Settings.json to scale all fonts
    property real fontSizeMultiplier: Settings.settings.fontSizeMultiplier || 1.0

    // Base font sizes (multiplied by fontSizeMultiplier)
    property int fontSizeHeader: Math.round(32 * fontSizeMultiplier)     // Headers and titles
    property int fontSizeBody: Math.round(16 * fontSizeMultiplier)       // Body text and general content
    property int fontSizeSmall: Math.round(14 * fontSizeMultiplier)      // Small text like clock, labels
    property int fontSizeCaption: Math.round(12 * fontSizeMultiplier)    // Captions and fine print
}
