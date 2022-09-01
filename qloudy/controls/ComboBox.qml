import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15  as T

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding,
                            implicitIndicatorHeight + topPadding + bottomPadding)
    leftPadding: 5 + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: 5 + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    spacing: 5

    editable: true
    selectTextByMouse: true
    palette { button: '#353637'; buttonText: "#fff"; highlight: '#33000000' }

    delegate: ItemDelegate {
        width: ListView.view.width
        height: control.height + padding/2
        font: control.font
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        palette.text: control.palette.buttonText
        palette.highlightedText: control.palette.highlightedText
        hoverEnabled: control.hoverEnabled

        background: Rectangle {
            radius: 1
            color: Qt.lighter(control.palette.button, control.currentIndex === index || hovered ? 1.3 : 1.)
            border.color: Qt.lighter(control.palette.button, 1.1)

            Rectangle {
                x: 2; y: 2
                width: parent.width - 4; height: parent.height - 4
                radius: 1
                color: 'transparent'
                border.color: control.palette.buttonText
                visible: control.currentIndex === index
            }
        }
    }

    indicator: Text {
        x: control.mirrored ? control.padding : control.availableWidth + control.spacing + 4
        y: control.topPadding + (control.availableHeight - height)/2
        width: implicitWidth
        color: control.palette.buttonText
        text: "\u2261"
        font.pixelSize: 12
        font.bold: true
        opacity: enabled ? 1 : 0.3
    }

    contentItem: T.TextField {
        leftPadding: !control.mirrored ? 12 : 13
        rightPadding: control.mirrored ? 12 : 13
        topInset: 3; bottomInset: 3
        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: !control.editable
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse

        font: control.font
        color: control.palette.windowText
        selectionColor: control.palette.highlight
        selectedTextColor: control.palette.highlightedText
        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            visible: control.enabled && control.editable && !control.flat
            color: control.palette.window
            opacity: parent.activeFocus && control.editable ? 1.0 : 0.9
            radius: 1
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }
    }

    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 20

        visible: !control.flat || control.down
        radius: 1
        color: control.palette.button
        border.width: 1
        border.color: Qt.lighter(control.palette.button, 1.1)
        opacity: control.down ? 0.8 : 1.0

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    popup: T.Popup {
        y: control.height + 2
        topMargin: 35
        bottomMargin: 15

        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)

        contentItem: ListView {
            id: listView
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            spacing: 2
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0
            T.ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
}
