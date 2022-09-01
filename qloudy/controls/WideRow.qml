import QtQuick 2.15

Row {
    readonly property real childrenWidth: ((...a) => a).apply(null, children).reduce((a, e) => a + e.width, 0)
    spacing: Math.max((width - childrenWidth - padding * 2)/(children.length-1), 0);
}
