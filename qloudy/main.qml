import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.platform 1.1

import qloudy.globals 0.1

import 'controls'
import 'windows'
import 'forms'

import 'scripts/weather.js' as WeatherIcons
import 'scripts/utils.js' as JsUtils

BaseWindow {
    id: window

    width: 460
    height: 360
    visible: true
    title: qsTr("Qloudy")

    property bool light: JsUtils.isDay(Weather.timezoneOffset)

    palette {
        button: light ? '#33000000' : '#33ffffff'
        buttonText: '#fff'

        window: '#343536'
        windowText: '#fff'

        highlight: '#33ffffff'
        highlightedText: '#fff'
    }

    MainForm {
        width: window.width
        height: window.height
    }

    SystemTrayIcon {
        id: systemTray
        visible: true
        icon.source: "qrc:/resources/icons/icon.svg"

        tooltip: `${Weather.description}\n` +
                 `Temp: ${Weather.currentTemp.toFixed(2)}\n` +
                 `Wind: ${Weather.windSpeed} - ${Weather.windDeg} \u00b0\n` +
                 `Lon: ${Weather.coordinate.x}\nLat: ${Weather.coordinate.y}\n` +
                 `City: ${Weather.city}\n`;

        onActivated: {
            if(reason === SystemTrayIcon.Trigger) {
                window.visible = true;
                window.show();
            }
        }

        menu: Menu {
            MenuItem {
                text: window.visible ? qsTr("Hide") : qsTr("Show")
                onTriggered: window.visible = !window.visible;
            }

            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit();
            }
        }
    }
}
