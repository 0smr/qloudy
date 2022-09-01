import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import Qloudy 0.1

import '../controls'
import '../scripts/citiesCoord.js' as CitiesCoord

BaseForm {
    id: form

    function setCoordinate(coordinate) {
        if(coordinate.lon && coordinate.lat) {
            longitude.input.text = coordinate.lon;
            latitude.input.text = coordinate.lat;
            settings.coordinate = Qt.point(coordinate.lon, coordinate.lat)
        }
    }

    Component.onCompleted: {
        longitude.input.text = settings.coordinate.x ?? 0;
        latitude.input.text = settings.coordinate.y ?? 0;
        tokenInput.input.text = settings.token ?? "";

        const province = settings.provinceName
        const city = settings.cityName

//        provinceCBox.currentIndex = CitiesCoord.provincesList.indexOf(province) ?? 0
//        cityCBox.currentIndex = (CitiesCoord.citiesOfProvinceList[province] ?? []).indexOf(city) ?? 0
    }

    component LabeledInput: Row {
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
        }
    }

    Settings {
        id: settings
        category: "Configuration/Coordinate"
        fileName: "config.ini"

        property string token: tokenInput.input.text ?? ""
        property string city: cityCBox.currentText ?? ""
        property string province: provinceCBox.currentValue ?? ""
        property point coordinate
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
            }
            LabeledInput {
                id: latitude;
                input.text: "0.0"
                label.text: "Latitude:"
            }
        }

        WideRow {
            width: Math.min(parent.width - 10, 450)
            ComboBox {
                id: provinceCBox
                font: { font = Qloudy.regularFont; font.pointSize = 8 }
                model: CitiesCoord.provincesList
            }

            ComboBox {
                id: cityCBox
                textRole: "city"
                valueRole: "crd"
                font: { font = Qloudy.regularFont; font.pointSize = 8 }
                model: CitiesCoord.citiesDict[provinceCBox.currentValue] ?? []

                onAccepted: form.setCoordinate(currentValue ?? {})
                onActivated: form.setCoordinate(currentValue ?? {})
            }
        }

        LabeledInput {
            id: tokenInput
            label.text: "Token:"
            input.validator: null
        }
    }
}
