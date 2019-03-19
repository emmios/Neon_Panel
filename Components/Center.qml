import QtQuick 2.9


Item {
    x: 0
    y: 0
    width: parent.width
    height: parent.height

    property double maxWidth: 800

    onWidthChanged: {
        if (width > maxWidth) {
            x = (width - (maxWidth + 20)) / 2
        }
    }
}
