import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC

import Qloudy 0.1

QQC.ToolTip {
    id: control
    delay: 500
    timeout: 2500
    font: Qloudy.regularFont
    palette.toolTipText: 'gray'

    background: Rectangle {
        color: '#f8f9fa'
        border { color: '#e9ecef'; width: 1 }
        radius: 2
    }
}
