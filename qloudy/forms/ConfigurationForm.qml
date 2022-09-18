import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import qloudy 0.1
import qloudy.globals 0.1

import '../controls'

BaseForm {
    id: form

    property var provinces: Utils.readJsonFile(":/resources/data/iran-province.json")
    property var citiesCoord: Utils.readJsonFile(":/resources/data/iran-cities-coord.json")

    function setCoordinate(coordinate) {
        if(coordinate.lon && coordinate.lat) {
            longitude.input.text = coordinate.lon;
            latitude.input.text = coordinate.lat;
            Weather.coordinate = Qt.point(coordinate.lon, coordinate.lat)
        }
    }

    Component.onCompleted: {
        longitude.input.text = Weather.coordinate.x ?? 0;
        latitude.input.text = Weather.coordinate.y ?? 0;
        tokenInput.input.text = Weather.token ?? "";
        provincesList.currentIndex = Weather.provinceIndex ?? 0
        citiesList.currentIndex = Weather.cityIndex ?? 0
    }

    component LabeledInput: Row {
        id: labeledInput
        signal edited()

        property alias label: label
        property alias input: textField

        spacing: 10
        width: childrenRect.width

        Label { id: label }

        TextField {
            id: textField
            width: Math.max(50, implicitWidth)
            palette.highlight: '#33000000'
            palette.highlightedText: color
            validator: DoubleValidator {
                bottom: 0; top: 100; decimals: 3
                notation: DoubleValidator.StandardNotation
            }
            onTextEdited: labeledInput.edited()
        }
    }

    Grid {
        anchors.fill: parent
        padding: 5
        spacing: 10
        flow: Grid.TopToBottom

        WideRow {
            width: Math.min(parent.width - 10, 450)
            LabeledInput {
                id: longitude;
                input.text: "0.0"
                label.text: "Longitude:"
                onEdited: Weather.coordinate = Qt.point(input.text, longitude.input.text)
            }
            LabeledInput {
                id: latitude;
                input.text: "0.0"
                label.text: "Latitude:"
                onEdited: Weather.coordinate = Qt.point(longitude.input.text, input.text)
            }
        }

        LabeledInput {
            id: tokenInput
            label.text: "Token:"
            input.validator: null
            onEdited: Weather.token = input.text
        }

        WideRow {
            width: Math.min(parent.width - 10, 450)

            Tumbler { id: provincesList
                property var currentValue: currentItem.text

                width: 150; height: 90
                model: form.provinces
                wrap: false
                visibleItemCount: 5
                delegate: Text {
                    font: Fonts.regular
                    color: form.palette.windowText
                    width: implicitWidth; height: font.pixelSize * 1.5
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.5 + (2 - Math.abs(Tumbler.displacement))/4
                    text: modelData
                }
                onCurrentIndexChanged: Weather.provinceIndex = currentIndex || Weather.provinceIndex
            }

            Tumbler { id: citiesList
                property var currentValue: cities[currentIndex]
                property var cities: form.citiesCoord[provincesList.currentValue ?? ""]

                width: 150; height: 90
                model: cities
                wrap: false
                visibleItemCount: 5
                delegate: Text {
                    font: Fonts.regular
                    color: form.palette.windowText
                    width: implicitWidth; height: font.pixelSize * 1.5
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.5 + Math.pow((2 - Math.abs(Tumbler.displacement))/2,2)
                    text: modelData["city"] ?? ""
                }

                onMovingChanged: {
                    if(!moving && !provincesList.moving) {
                        form.setCoordinate((cities[currentIndex] ?? {})["crd"] ?? {});
                    }
                }
                onCurrentIndexChanged: Weather.cityIndex = currentIndex || Weather.cityIndex
            }
        }
    }
}
