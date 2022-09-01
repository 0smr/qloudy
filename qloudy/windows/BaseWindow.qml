import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import Qloudy 0.1

import '../controls'

Window {
    id: window

    width: 400; height: 350
    color: 'transparent'
    flags: Qt.Window | Qt.FramelessWindowHint

    default property alias contentData: page.contentData
    property alias palette: page.palette

    component HeaderButton: AbstractButton {
        id: btn
        width: 20
        height: parent.height
        contentItem: Text {
            width: btn.width
            text: btn.text
            color: btn.palette.buttonText
            font: btn.font
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }
        background: Rectangle { color: btn.palette.button }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        propagateComposedEvents: true

        property int edges: 0;
        property int edgeOff: 5;

        function setEdges(x, y) {
            edges = 0;
            if(x < edgeOff) edges |= Qt.LeftEdge;
            if(x > (width - edgeOff))  edges |= Qt.RightEdge;
            if(y < edgeOff) edges |= Qt.TopEdge;
            if(y > (height - edgeOff)) edges |= Qt.BottomEdge;
        }

        cursorShape: {
            return !containsMouse ? Qt.ArrowCursor:
                   edges == 3 || edges == 12 ? Qt.SizeFDiagCursor :
                   edges == 5 || edges == 10 ? Qt.SizeBDiagCursor :
                   edges & 9 ? Qt.SizeVerCursor :
                   edges & 6 ? Qt.SizeHorCursor : Qt.ArrowCursor;
        }

        onPositionChanged: setEdges(mouseX, mouseY);
        onPressed: {
            setEdges(mouseX, mouseY);
            if(edges && containsMouse) {
                startSystemResize(edges);
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: '#353637'
    }

    Page {
        id: page

        clip: true
        anchors.fill: parent
        anchors.margins: window.visibility === Window.Maximized ? 0 : 5

        header: Rectangle {
            id: header
            height: 20;
            clip: true
            color: "#353637";

            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    window.visibility === Window.Maximized ?
                                window.showNormal() : window.showMaximized();
                }
            }

            Row {
                leftPadding: 4
                anchors.fill: parent

                Image {
                    id: logo
                    y: 4
                    source: "qrc:/resources/icons/icon-light.svg"
                    height: parent.height - 8
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: title
                    height: parent.height
                    leftPadding: 3
                    color: '#ddd'
                    text: window.title
                    font: Qloudy.regularFont
                    verticalAlignment: Qt.AlignVCenter
                }

                Item {
                    width: header.width - title.width - logo.width - hideBtn.width - closeBtn.width - 4
                    height: parent.height
                }

                HeaderButton {
                    id: hideBtn
                    text: '\uef9a'
                    font: Qloudy.iconFont
                    palette {
                        buttonText: "#eee"
                        button: Qt.lighter("#353637", hovered ? 1.3 : 1.0)
                    }
                    onClicked: window.hide();
                }

                HeaderButton {
                    id: closeBtn
                    text: '\ueee4'
                    font: Qloudy.iconFont
                    palette {
                        buttonText: "#eee"
                        button: hovered ? '#f44' : '#353637'
                    }
                    onClicked: window.close();
                }
            }

            DragHandler {
                target: null
                dragThreshold: 1
                onActiveChanged: if(active) window.startSystemMove();
            }
        }
    }
}
