pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Control {
    id: control

    property string description: ""
    property string city: ""
    property int conditionCode: 0
    property real currentTemp: 0
    property real windSpeed: 0
    property real windDeg: 0

    property string forecastData: ""

    property point coordinate: Qt.point(0,0)
    property real cityIndex: 0
    property real provinceIndex: 0
    property real timezoneOffset: 0
    property string token: ""

    property real nowcastLastUpdate: 0
    property real forecastLastUpdate: 0

    Settings {
        category: "Configuration/WeatherData/Nowcast"
        fileName: "config.ini"

        property alias lastUpdate: control.nowcastLastUpdate
        property alias city: control.city
        property alias description: control.description
        property alias conditionCode: control.conditionCode
        property alias currentTemp: control.currentTemp
        property alias windSpeed: control.windSpeed
        property alias windDeg: control.windDeg
    }

    Settings {
        id: forecast
        category: "Configuration/WeatherData/Forecast"
        fileName: "config.ini"

        property alias lastUpdate: control.forecastLastUpdate
        property alias forecastData: control.forecastData
    }

    Settings {
        category: "Configuration/Coordinate"
        fileName: "config.ini"

        property alias token: control.token
        property alias coordinate: control.coordinate
        property alias cityIndex: control.cityIndex
        property alias provinceIndex: control.provinceIndex
        property alias timezoneOffset: control.timezoneOffset
    }
}
