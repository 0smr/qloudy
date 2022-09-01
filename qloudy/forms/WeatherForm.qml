import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qloudy 0.1
import qloudy.network.weather 0.1

import '../controls'

BaseForm {
    id: form

    property int mainWeatherConditionCode: currentWeather.conditionCode / 100

    background: Image {
        id: backgroundImage
        source: {
            const images = [
                "", // 1
                "", // 2
                "", // 3
                "", // 4
            ];

            return images[mainWeatherConditionCode] ?? "";
        }
    }

    Flickable {
        anchors.fill: parent
        contentWidth: grid.width
        contentHeight: grid.height
        boundsMovement: Flickable.StopAtBounds

        Grid {
            id: grid

            width: form.width

            spacing: 10
            flow: Grid.TopToBottom

            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

            CurrentWeather {
                id: currentWeather
            }

            WeekForecast {
                width: parent.width - parent.padding * 2
            }
        }
    }
}
