import QtQuick 2.15

Item {
    id: control

    property var source
    property bool running: timer.running

    Timer {
        id: timer
        running: control.running
        repeat: true; interval: 45
        onTriggered: effect.seed -= 2e-2
    }

    ShaderEffect {
        id: effect
        anchors.fill: parent

        property var source: control.source
        property real seed: 1e5
        property vector2d ratio: {
            const max = Math.max(width, height);
            return Qt.vector2d(width/max, height/max)
        }

        fragmentShader: "qrc:/controls/effects/shaders/rainy.frag"
    }
}
