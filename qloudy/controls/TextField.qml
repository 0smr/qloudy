import QtQuick 2.15
import QtQuick.Templates 2.15 as T

import Qloudy 0.1

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    font: Qloudy.regularFont
    selectByMouse: true
    horizontalAlignment: TextInput.AlignHCenter

    color: control.palette.windowText
    selectionColor: control.palette.highlight
    selectedTextColor: control.palette.highlightedText
    placeholderTextColor: control.palette.text
    verticalAlignment: TextInput.AlignVCenter

    Text {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding  + control.rightPadding)
        height: control.height  - (control.topPadding   + control.bottomPadding)

        text: control.placeholderText
        font: control.font

        color: control.placeholderTextColor

        verticalAlignment: control.verticalAlignment
        visible: !control.length && !control.preeditText &&
                 (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
        elide: Text.ElideRight
        renderType: control.renderType
    }

    background: Item {
        implicitWidth: control.contentWidth
        implicitHeight: control.contentHeight

        opacity: control.activeFocus ? 1 : 0.5

        Rectangle {
            y: parent.height - 1
            width: parent.width; height: 1
            color: control.palette.windowText
        }
    }
}
