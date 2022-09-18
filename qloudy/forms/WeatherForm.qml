import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import qloudy.globals 0.1

import '../controls'

BaseForm {
    id: form

    property Item back:
        BackgroundTheme {
            contentY: flickable.contentY
            conditionCode: Weather.conditionCode
        }

    BusyIndicator {
        width: 25
        height: width
        running: currentWeather.requestHandler.processing ||
                 weekForecast.requestHandler.processing
    }

    Flickable {
        id: flickable

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
                id: weekForecast
                width: parent.width - parent.padding * 2
            }
        }
    }
}
