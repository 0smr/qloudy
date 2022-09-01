pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

Control {
    id: control

    property font iconFont
    property font monoFont
    property font regularFont
    property font subscriptFont
    property font boldFont
    property font headFont

    Component.onCompleted: {
        iconFont.pointSize = 9;
        monoFont.pointSize = 9;
        subscriptFont.pointSize = 7;
        regularFont.pointSize = 9;
        boldFont.pointSize = 9;
        headFont.pointSize = 17;

        iconFont.family = icofont.name || "icofont";
        monoFont.family = courierPrimeCode.name;
        subscriptFont.family = carlito.name;
        regularFont.family = carlito.name;
        boldFont.family = carlito.name;
        headFont.family = carlito.name;

        boldFont.bold = true;
        headFont.bold = true;
        boldFont.weight =  Font.ExtraBold
        headFont.weight =  Font.ExtraBold
    }

    FontLoader {
        id: carlito
        source: "qrc:/resources/font/Carlito-Regular.ttf"
    }

    FontLoader {
        id: courierPrimeCode
        source: "qrc:/resources/font/Courier Prime Code.ttf"
    }

    FontLoader {
        id: icofont
        source: "https://unpkg.com/@icon/icofont@1.0.1-alpha.1/icofont.ttf"
        onStatusChanged: {
            if(status === FontLoader.Ready) iconFont.family = icofont.name;
        }
    }

    Settings {
        fileName: "config.ini"
        category: "Theme/Font"

        property alias regularFamily: control.regularFont.family
        property alias regularPointSize: control.regularFont.pointSize
        property alias monoFamily: control.monoFont.family
        property alias monoPointSize: control.monoFont.pointSize
    }
}
