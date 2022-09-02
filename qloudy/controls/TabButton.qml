import QtQuick 2.15
import QtQuick.Controls 2.15

AbstractButton {
    id: control

    property alias iconx: icon

    spacing: 5
    padding: 0
    bottomPadding: 5

    display: AbstractButton.IconOnly

    checkable: true
    autoExclusive: true
    checked: (parent.currentIndex ?? 0)  === Positioner.index

    onCheckedChanged: {
        if(checked && parent.currentIndex !== undefined)
            parent.currentIndex = Positioner.index
    }

    background: Item {}

    contentItem: Row {
        opacity: control.checked ? 1.0 : 0.4
        spacing: icon.visible && text.visible ? control.spacing : 0
        Text {
            id: icon
            text: ""
            color: control.palette.buttonText
            visible:(control.display == AbstractButton.IconOnly ||
                     control.display == AbstractButton.TextBesideIcon) && text;
        }

        Text {
            id: text

            visible: control.display == AbstractButton.TextOnly ||
                     control.display == AbstractButton.TextBesideIcon;

            height: 10
            text: control.text
            color: control.palette.buttonText
            font: control.font
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }
}
