import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import Qt.labs.settings 1.1

import qloudy 0.1
import qloudy.globals 0.1

import '../controls'
import '../scripts/weather.js' as WeatherIcons
import '../scripts/utils.js' as Utils

BaseForm {
    id: form

    height: Math.max(weekForecast.contentHeight, (weekForecast.currentItem ?? {}).height)

    property alias requestHandler: requestHandler

    Connections {
        target: Weather
        function onCoordinateChanged() {
            requestHandler.updateWeather();
        }
    }

    ListModel {
        id: weekForecastModel

        signal updated()

        function toArray() {
            return Array.from({length: count}, (x,i) => get(i));
        }

        function fromArray(array) { // update model data from array.
            array.forEach((x, i) => { if(i<count) set(i, x); else append(x); });
        }

        onUpdated: {
            Weather.forecastData = JSON.stringify(toArray());
        }

        Component.onCompleted: {
            // Initial data to fill model.
            const initData = { wday: '-', description: '-', conditionCode: 0,
                               tmin: 0, tmax: 0, windSpeed: 0, windDeg: 0 };
            const array = JSON.parse(Weather.forecastData || "[]");
            // Assing array to model.
            fromArray(array.length ? array : Array(5).fill(initData));
        }
    }

    Timer {
        running: true
        triggeredOnStart: true
        interval: 1 * 60 * 60 * 1000 // Will trigger every one hour.
        onTriggered: {
            // If it has been more than 10 hours since the last update, renew the forecast data.
            if(Date.now() - Weather.forecastLastUpdate > 36000000) {
                requestHandler.updateWeather();
            }
        }
    }

    RequestHandler {
        id: requestHandler

        function updateWeather() {
            const coordinate = Weather.coordinate;
            const token = Weather.token;
            if(token && coordinate.x && coordinate.y) {
                const request = `https://api.openweathermap.org/data/2.5/forecast?` +
                                `lon=${coordinate.x}&lat=${coordinate.y}&appid=${token}&lang=fa`;
                getRequest(request);
            }
        }

        onFinished: {
            let data = {};
            try { data = JSON.parse(response) } catch(e) {}
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
                        wday: Utils.dayOfWeekString(Weather.timezoneOffset, morning.dt),
                        description: description,
                        conditionCode: conditionCode,
                        tmin: minTemp, tmax: maxTemp,
                        windSpeed: windSpeed, windDeg: windDeg
                    });
                }
                weekForecastModel.updated()
                Weather.forecastLastUpdate = Date.now(); // Renew last update time.
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

            width: {form.visible; !vertical ? Math.min(form.width, contentWidth) : form.width}
            height: vertical ? contentHeight : (currentItem ?? {}).height

            property bool vertical: form.width < 300
            orientation: vertical ? ListView.TopToBottom : ListView.LeftToRight

            model: weekForecastModel

            maximumFlickVelocity: 350
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5

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
                            font = Fonts.icon.family
                            font.pointSize = weekForecast.vertical ? 13 : 20
                        }
                    }
                    Label { text: model.wday }

                    Row {
                        spacing: 5
                        Label {
                            font.pointSize: 10
                            text: (model.tmin - 273.15).toFixed(1) + '\u00b0'
                        }
                        Label {
                            topPadding: 5
                            font: { font = Fonts.regular; font.pointSize = 8 }
                            text: (model.tmax - 273.15).toFixed(1) + '\u00b0'
                        }
                    }

                    Label { text: model.description; font.pointSize: 7 }

                    Row {
                        Label { text: model.windSpeed.toFixed() + 'mps' }
                        Label { text: "\ue133"; rotation: model.windDeg; font: Fonts.icon }
                    }
                }
            }
        }
    }
}
