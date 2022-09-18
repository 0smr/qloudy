import QtQuick 2.12

import qloudy.globals 0.1

Item {
    id: control

    property string text
    property alias font: displayText.font
    property alias color: displayText.color
    property alias elide: displayText.elide
    property alias wrapMode: displayText.wrapMode
    property alias displayText: displayText

    implicitWidth: displayText.implicitWidth
    implicitHeight: displayText.implicitHeight

    QtObject {
        id: internals
        property string last
        property int num

        NumberAnimation on num {
            id: numAnim
            from: 0; to: 128
            duration: 750
            easing.type: Easing.InCubic
        }
    }

    onTextChanged: {
        internals.last = displayText.text;
        numAnim.restart();
    }

    Connections {
        target: internals
        function onNumChanged() {
            const len = control.text.length;
            const proc = internals.num / numAnim.to;
            let text = "";
            for(let i = 0; i < len; ++i) {
                const fromCC = internals.last.charCodeAt(i) || 48 + i % 50;
                const toCC = control.text.charCodeAt(i);
                const diffCC = (toCC - fromCC) * proc;
                const res = String.fromCharCode((fromCC + diffCC).toFixed());
                text += res;
            }
            displayText.text = text;
        }
    }

    Text {
        id: displayText
        width: parent.width
        font: Fonts.mono
    }
}
