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

    property string token: { visible; coordConfig.value("token") }
    property point coordinate: { visible; coordConfig.value("coordinate") }

    height: Math.max(weekForecast.contentHeight, (weekForecast.currentItem ?? {}).height)

    onCoordinateChanged: {
        timer.force = true; // In case of coordinate change, force update.
        timer.restart();
    }

    Component.onCompleted: {
        // Initial data to fill model.
        const initData = { wday: '-', description: '-', conditionCode: 0,
                           tmin: 0, tmax: 0, windSpeed: 0, windDeg: 0 };
        // Read data from settings as json.
        const array = JSON.parse(weatherData.value("forecastData") ?? "[]");
        // Assing array to model.
        weekForecastModel.fromArray(array.length ? array : Array(5).fill(initData));
    }

    Component.onDestruction: {
        // Save data on destruction.
        const array = weekForecastModel.toArray();
        weatherData.setValue("forecastData", JSON.stringify(array));
    }

    Settings {
        id: coordConfig
        category: "Configuration/Coordinate"
        fileName: "config.ini"
    }

    Settings {
        id: weatherData
        category: "Configuration/WeatherData/Forecast"
        fileName: "config.ini"

        property real lastUpdate
        property string forecastData
    }

    ListModel {
        id: weekForecastModel
        function toArray() {
            return Array.from({length: count}, (x,i) => get(i));
        }

        function fromArray(array) { // update model data from array.
            array.forEach((x, i) => { if(i<count) set(i, x); else append(x); });
        }
    }

    Timer {
        id: timer
        property bool force: false

        running: true
        triggeredOnStart: true
        interval: 1 * 60 * 60 * 1000 // Will trigger every hour.

        onTriggered: {
            const coordinate = form.coordinate;
            const token = form.token;
            // If it has been more than 10 hours since the last update, renew the forecast data..
            const isOld = Date.now() - weatherData.lastUpdate < 36000000;

            if(token && coordinate.x && coordinate.y && (isOld || force)) {
                const request = `https://api.openweathermap.org/data/2.5/forecast?` +
                                `lon=${coordinate.x}&lat=${coordinate.y}&appid=${token}&lang=fa`;
                fiveDayWeather.getRequest(request);

                weatherData.lastUpdate = Date.now(); // Update lastUpdate time.
                force = false; // Remove force flag.
            }
        }
    }

    RequestHandler {
        id: fiveDayWeather

        onFinished: {
            let data = JSON.parse(response)
            if(data.cod === "200") { // If there was no error
                const count  = Math.min(weekForecastModel.count, (data.cnt ?? 0)/8);
                const list = data.list;

                for(let i = 0; i < count; ++i) {
                    const morning = list[i * 8]; // morning, day {i}
                    const noon = list[i * 8 + 4]; // noon, day {i}

                    const conditionCode = noon.weather[0].id;
                    const description = noon.weather[0].description;

                    const minTemp = morning.main.temp_min;
                    const maxTemp = noon.main.temp_max;

                    const windSpeed = noon.wind.speed;
                    const windDeg = noon.wind.deg;

                    weekForecastModel.set(i, {
                        wday: Utils.utcDayOfWeek(morning.dt),
                        description: description,
                        conditionCode: conditionCode,
                        tmin: minTemp, tmax: maxTemp,
                        windSpeed: windSpeed, windDeg: windDeg
                    });
                }
            }
        }

        onErrorOccurred: {
            print(errorMessage)
        }
    }

    contentItem: Item {
        ListView {
            id: weekForecast
            spacing: 5
            anchors.centerIn: parent

            width: !vertical ? Math.min(form.width, contentWidth) : form.width
            height: vertical ? contentHeight : (currentItem ?? {}).height

            property bool vertical: form.width < 300
            orientation: vertical ? ListView.TopToBottom : ListView.LeftToRight

            model: weekForecastModel

            boundsBehavior: Flickable.OvershootBounds
            preferredHighlightBegin:  0.5
            preferredHighlightEnd:  0.5

            delegate: Control {
                width: weekForecast.vertical ? weekForecast.width : implicitWidth
                padding: 10

                background: Rectangle {
                    color: palette.button
                    radius: 5
                }

                contentItem: Grid {
                    x: (parent.width - width)/2
                    spacing: weekForecast.vertical ? 8 : 0
                    flow: weekForecast.vertical ? Grid.LeftToRight : Grid.TopToBottom
                    horizontalItemAlignment: Grid.AlignHCenter
                    verticalItemAlignment: Grid.AlignVCenter

                    Label {
                        text: WeatherIcons.icon(model.conditionCode)
                        font: {
                            font = Qloudy.iconFont.family
                            font.pointSize = weekForecast.vertical ? 13 : 20
                        }
                    }
                    Label { text: model.wday }

                    Row {
                        spacing: 5
                        Label {
                            font.pointSize: 10
                            text: (model.tmin - 273.15).toFixed(1) + '\u00B0'
                        }
                        Label {
                            topPadding: 5
                            font: { font = Qloudy.regularFont; font.pointSize = 8 }
                            text: (model.tmax - 273.15).toFixed(1) + '\u00B0'
                        }
                    }

                    Label { text: model.description; font.pointSize: 7 }

                    Row {
                        Label { text: model.windSpeed.toFixed() + 'mps' }
                        Label { text: "\uea5e"; rotation: model.windDeg; font: Qloudy.iconFont }
                    }
                }
            }
        }
    }
}
