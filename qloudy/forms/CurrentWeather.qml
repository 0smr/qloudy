import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import qloudy 0.1
import qloudy.globals 0.1

import '../controls'
import '../scripts/weather.js' as WeatherIcons
import '../scripts/utils.js' as Utils

BaseForm {
    id: form

    property alias requestHandler: requestHandler

    Connections {
        target: Weather
        function onCoordinateChanged() {
            requestHandler.updateWeather();
        }
    }

    Settings {
        id: coordConfig
        category: "Configuration/Coordinate"
        fileName: "config.ini"
    }

    RequestHandler {
        id: requestHandler

        function updateWeather() {
            const coordinate = Weather.coordinate;
            const token = Weather.token;
            if(token && coordinate.x && coordinate.y) {
                const request = `https://api.openweathermap.org/data/2.5/weather?` +
                                `lon=${coordinate.x}&lat=${coordinate.y}&appid=${token}&lang=fa`;
                requestHandler.getRequest(request);
            }
        }

        onFinished: {
            let data = {};
            try { data = JSON.parse(response); } catch(e) {}
            if(data.cod === 200) {
                Weather.conditionCode = data.weather[0].id ?? 0;
                Weather.description = data.weather[0].description;
                Weather.currentTemp = data.main.temp - 273.15;
                Weather.windSpeed = data.wind.speed;
                Weather.windDeg = data.wind.deg;
                Weather.city = data.name;
                Weather.timezoneOffset = data.timezone;
            }
            Weather.nowcastLastUpdate = Date.now(); // Renew last update time.
        }

        onErrorOccurred: {
            print(errorMessage);
            timer.restart()
        }
    }

    Timer {
        id: timer

        running: true
        triggeredOnStart: true
        interval: 300000 // Will trigger every 5 minute.

        onTriggered: {
            // If it has been more than 15 minute since the last update, renew the weather data.
            if(Date.now() - Weather.nowcastlastUpdate > 900000) {
                requestHandler.updateWeather();
            }
        }
    }

    contentItem: Grid {
        horizontalItemAlignment: Grid.AlignHCenter

        Label {
            text: `lon: ${Weather.coordinate.x} | lat: ${Weather.coordinate.y}`
            font.pointSize: 6
            opacity: 0.5
        }

        Grid {
            horizontalItemAlignment: Grid.AlignHCenter
            Label { text: Weather.city || "?"; font: Fonts.head }
//            Label { text: Weather.province || ""; font.pointSize: 8 }
        }

        Label {
            text: WeatherIcons.icon(Weather.conditionCode, Utils.isDay())
            font: { font = Fonts.icon; font.pointSize = 50 }
            renderType: Label.NativeRendering
        }

        Grid {
            spacing: 15
            flow: Grid.LeftToRight
            verticalItemAlignment: Grid.AlignVCenter
            Label {
                text: Weather.currentTemp.toFixed() + '\u00B0 C'
                font.pointSize: 18
            }
        }

        Row {
            spacing: 5
            Label { text: "Wind: " }
            Label { text: Weather.windSpeed.toFixed(1) + 'mps' }
            Label { text: "| Direction " + Weather.windDeg.toFixed() + '\u00b0' }
            Label { text: "\ue133"; font: Fonts.icon; rotation: Weather.windDeg }
        }

        Row {
            spacing: 5
            Label { text: Utils.dayOfWeekString(Weather.timezoneOffset) + " -"; font: Fonts.regular }
            Label { text: Weather.description; font: Fonts.regular }
        }
    }
}
