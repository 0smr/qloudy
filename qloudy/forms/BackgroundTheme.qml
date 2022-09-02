import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import QtGraphicalEffects 1.15 // TODO: replace this

import '../controls'
import '../controls/effects'
import '../scripts/utils.js' as Utils

Item {
    id: control

    property int conditionCode: 8
    property int mainCode: Math.floor(control.conditionCode / 100) + (conditionCode > 800)
    property real contentY: 10

    readonly property var themes: {
        1: { // TODO: fix 7 and 9 conditions.
            0: "qrc:/resources/backgrounds/clear.webp", // Default
            2: "qrc:/resources/backgrounds/tornado.webp", // Thunderstorm
            3: "qrc:/resources/backgrounds/dark-cloud.webp", // Drizzle
            5: "qrc:/resources/backgrounds/dark-cloud.webp", // Rain
            6: "qrc:/resources/backgrounds/snowy.webp", // Snow
            7: "qrc:/resources/backgrounds/fog.webp", // Atmosphere
            8: "qrc:/resources/backgrounds/clear.webp", // Clear
            9: "qrc:/resources/backgrounds/cloudy-2.webp", // Cloudy
        },
        "-1": {
            0: "qrc:/resources/backgrounds/clear-night-2.webp", // Default
            8: "qrc:/resources/backgrounds/clear-night-2.webp", // Clear
            9: "qrc:/resources/backgrounds/cloudy-night.webp", // Cloudy
        }
    }

    property list<Component> effects: [
        Component { ShaderEffect { } }, // No effect
        Component { Rainy { running: true } }, // Rain effect
        Component { FastBlur { radius: 15 } }
    ]

    layer.enabled: true
    layer.effect: effects[mainCode == 5 ? 1 : 0]

    Image {
        id: backgroundImage
        y: -control.contentY * 0.2
        width: parent.width
        height: parent.height + 50

        fillMode: Image.PreserveAspectCrop

        source: {
            const time = Utils.isDay() ? 1 : -1;
            return control.themes[time][control.mainCode] ??
                   control.themes[-time][0]; // If there was no theme
        }
    }
}
