import QtQuick 2.15
import QtQuick.Window 2.15

import 'controls'
import 'windows'
import 'forms'

BaseWindow {
    id: window

    width: 460
    height: 360
    visible: true
    title: qsTr("Qloudy")

//    palette.window: '#fff'

    MainForm {
        width: window.width
        height: window.height
    }
}
