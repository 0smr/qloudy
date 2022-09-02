import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qloudy 0.1
import qloudy.network.weather 0.1

import '../controls'
import '../scripts/weather.js' as WeatherIcons
import '../scripts/utils.js' as Utils

BaseForm {
    id: form

    property string description: ""
    property int conditionCode: 0

    property real currentTemp: 0.0
    property real minTemp: 0.0
    property real maxTemp: 0.0
    property real windSpeed: 0.0
    property real windDeg: 0.0

    property string city: ""

    // A tricky technique to have properties read settings info from the most recent update.
//    property string city: { visible; coordConfig.value("city") }
    property string province: { visible; coordConfig.value("province") }
    property string token: { visible; coordConfig.value("token") }
    property point coordinate: { visible; coordConfig.value("coordinate") }

    onCoordinateChanged: {
        timer.force = true; // In case of coordinate change, force update.
        timer.restart();
    }

    Settings {
        id: coordConfig
        category: "Configuration/Coordinate"
        fileName: "config.ini"
    }

    Settings {
        id: weatherData
        category: "Configuration/WeatherData/Nowcast"
        fileName: "config.ini"

        property real lastUpdate
        property alias city: form.city
        property alias description: form.description
        property alias conditionCode: form.conditionCode
        property alias currentTemp: form.currentTemp
        property alias minTemp: form.minTemp
        property alias maxTemp: form.maxTemp
        property alias windSpeed: form.windSpeed
        property alias windDeg: form.windDeg
    }

    RequestHandler {
        id: currentWeather

        onFinished: {
            let data = {};
            try { data = JSON.parse(response); } catch(e) {}

            if(data.cod === 200) {
                form.conditionCode = data.weather[0].id ?? 0;
                form.description = data.weather[0].description;
                form.currentTemp = data.main.temp - 273.15;
                form.minTemp = data.main.temp_min - 273.15;
                form.maxTemp = data.main.temp_max - 273.15;
                form.windSpeed = data.wind.speed;
                form.windDeg = data.wind.deg;
                form.city = data.name;
            }
        }

        onErrorOccurred: {
            print(errorMessage);
        }
    }

    Timer {
        id: timer
        property bool force: false

        running: true
        triggeredOnStart: true
        interval: 300000 // Will trigger every 5 minute.

        onTriggered: {
            let coordinate = form.coordinate;
            let token = form.token;
            // If it has been more than 15 minute since the last update, renew the weather data.
            const isOld = Date.now() - weatherData.lastUpdate < 900000;

            if(token && coordinate.x && coordinate.y && (isOld || force)) {
                const request = `https://api.openweathermap.org/data/2.5/weather?` +
                                `lon=${coordinate.x}&lat=${coordinate.y}&appid=${token}&lang=fa`;
                currentWeather.getRequest(request);

                weatherData.lastUpdate = Date.now(); // Update lastUpdate time.
                force = false; // Remove force flag.
            }
        }
    }

    contentItem: Grid {
        horizontalItemAlignment: Grid.AlignHCenter

        Label {
            text: `lon: ${form.coordinate.x} | lat: ${form.coordinate.y}`
            font.pointSize: 6
            opacity: 0.5
        }

        Grid {
            horizontalItemAlignment: Grid.AlignHCenter
            Label { text: form.city || "?"; font: Qloudy.headFont }
//            Label { text: form.province || ""; font.pointSize: 8 }
        }

        Label {
            text: WeatherIcons.icon(form.conditionCode, Utils.isDay())
            font: { font = Qloudy.iconFont; font.pointSize = 50 }
            renderType: Label.NativeRendering
        }

        Grid {
            spacing: 15
            flow: Grid.LeftToRight
            verticalItemAlignment: Grid.AlignVCenter
            Label {
                text: form.currentTemp.toFixed() + '\u00B0 C'
                font.pointSize: 18
            }
        }

        Row {
            spacing: 5
            Label { text: "Wind: " }
            Label { text: form.windSpeed.toFixed(1) + 'mps' }
            Label { text: "| Direction " + form.windDeg.toFixed() + '\u00b0' }
            Label { text: "\uea5e"; font: Qloudy.iconFont; rotation: form.windDeg }
        }

        Row {
            spacing: 5
            Label { text: Utils.dayOfWeek() + " -"; font: Qloudy.regularFont }
            Label { text: form.description; font: Qloudy.regularFont }
        }
    }
}
