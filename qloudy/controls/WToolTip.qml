import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import Qloudy 0.1

Item {
    id: control

    property alias delay: delayTimer.interval
    property alias timeout: timeoutTimer.interval
    property alias contentItem: innerControl.contentItem
    property alias background: innerControl.background

    property string text: ''
    property font font: Qloudy.regularFont
    property real offset: 0
    property real align: Qt.AlignRight

    signal finished()

    function terminate() {
        delayTimer.stop();
        timeoutTimer.stop();
    }

    function restart() {
        delayTimer.stop();
        timeoutTimer.stop();
        delayTimer.restart();
    }

    visible: false
    onVisibleChanged: {
        if(visible) delayTimer.restart();
        else terminate();
    }

    Timer {
        id: delayTimer
        interval: 500

        onTriggered: {
            const offset = control.offset -
                           (control.align == Qt.AlignRight ? 0 : innerControl.width)
            const coord = mapToGlobal(offset, 0);
            win.x = Math.min(coord.x + 5, Screen .width - win.width - 10);
            win.y = Math.min(Math.max(10, coord.y - 10), Screen.height - win.height - 10);
            timeoutTimer.restart();
        }
    }

    Timer {
        id: timeoutTimer
        interval: 1500
    }

    Window {
        id: win
        width: tooltiptext.width
        height: tooltiptext.height
        visible: control.visible && timeoutTimer.running && tooltiptext.text;
        color: 'transparent'
        flags: Qt.FramelessWindowHint |
               Qt.WindowTransparentForInput |
               Qt.WindowStaysOnTopHint |
               Qt.WA_DeleteOnClose

        onVisibleChanged: {
            if(!visible) {
                control.finished();
            }
        }

        Control {
            id: innerControl
            width: tooltiptext.implicitWidth
            height: tooltiptext.implicitHeight
            contentItem: Text {
                id: tooltiptext
                text: control.text
                font: control.font
                color: 'gray'
                padding: 5
            }

            background: Rectangle {
                color: '#f8f9fa'
                border { color: '#e9ecef'; width: 1 }
                radius: 2
            }
        }
    }
}
