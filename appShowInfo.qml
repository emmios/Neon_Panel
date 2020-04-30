import QtQuick 2.9
import QtQuick.Controls 2.2


ApplicationWindow {
    id: showInfos
    x: 10
    y: 10
    width: 160
    height: 30
    color: "transparent"
    title: qsTr("Neon Painel")
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

    property var winIds: []
    property string nome: ""

    onActiveChanged: {
        if (!active) {
            showInfos.visible = false
            showInfos.winIds = []
            listModel.clear()
        } else {
            main.unfix.visible = false
            main.fixShowInfos.visible = false
        }
    }

    Rectangle {
        id: showInfosBg
        anchors.fill: parent
        color: main.detailInfoColor
        opacity: 0.8
        radius: 0
    }

    Timer {
        id: activeDelay
        running: false
        interval: 100
        repeat: false
        property int win: 0
        onTriggered: {
            Context.windowActive(win)
        }
    }

    Timer {
        id: closeDelay
        running: false
        interval: 100
        repeat: false
        onTriggered: {
            for (var i = 0; i < winIds.length; i++) {
                Context.windowClose(winIds[i]);
            }

            showAppInfo.visible = false
        }
    }

    ListView {
        id: listView
        x: 0
        y: 0
        anchors.fill: parent

        model: ListModel {
            id: listModel

            /*
            ListElement {
                name: "test"
            }*/
        }
        delegate: Item {
            x: 0
            y: 0
            anchors.fill: parent

            Rectangle {
                x: 0
                y: rectY
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: 30
                color: "transparent"

                property int winId: 0
                property bool closer: closerX

                MouseArea {

                    anchors.fill: parent
                    hoverEnabled: true

                    onPressed: {
                        if (!parent.closer) {
                            activeDelay.win = winId
                            activeDelay.stop()
                            activeDelay.start()
                        } else {
                            closeDelay.stop()
                            closeDelay.start()
                        }
                    }

                    onHoveredChanged: {
                        parent.color = main.detailColor
                    }

                    onExited: {
                        parent.color = "transparent"
                    }
                }
            }

            Text {
                x: 0
                y: textY
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: 30
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
                color: "#ffffff"
                text: name
                font.family: main.fontName
            }
        }
    }

    function setText() {

        listModel.clear()
        showInfos.height = 30

        var y = 0

        for (var i = 0; i < winIds.length; i++) {

            nome = Context.windowName(winIds[i])

            if (nome.length >= 26) {
                nome = nome.substring(0, 20) + "..."
            }

            listModel.append({closerX: false, winId: winIds[i], rectY : y, name: nome, textY: y})


            if (i + 1 < winIds.length) {
                showInfos.height += 30
                showInfos.y -= 30
                y += 30
            }
        }

        if (winIds.length > 0) {

            showInfosBg.opacity = 0.75

            nome = winIds.length > 1 ? "Fechar Todas X" : "Fechar X"

            showInfos.height += 30
            showInfos.y -= 30
            y += 30

            listModel.append({closerX: true, winId: 0, rectY : y, name: nome, textY: y})

        } else {
            showInfosBg.opacity = 0.0
        }
    }
}
