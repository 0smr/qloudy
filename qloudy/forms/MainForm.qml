import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1

import qloudy.globals 0.1

import '../controls'

BaseForm {
    id: form

    background: weatherForm.back

    TabLayout {
        id: tabView

        clip: true
        padding: 8
        anchors.fill: parent
        currentIndex: 0

        tabs: [
            { text:'Weather', icon: '\ue30a'},
            { text:'Configuration', icon: '\ue00e'},
        ]

        WeatherForm { id: weatherForm }
        ConfigurationForm { }
    }
}
