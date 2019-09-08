import QtQuick 2.9
import QtQuick.Controls 2.2


ApplicationWindow {
    id: fixShowInfos
    x: 10
    y: 10
    width: 160
    height: 30
    color: "transparent"
    title: qsTr("Neon Painel")
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

    property var winIds: []
    property string nome: ""
    property string exec: ""

    onActiveChanged: {
        if (!active) {
            fixShowInfos.visible = false
            fixShowInfos.winIds = []
            listModel.clear()
        } else {
            main.showAppInfo.visible = false
            main.unfix.visible = false
        }
    }

    Rectangle {
        id: showInfosBg
        anchors.fill: parent
        color: "#000000"
        opacity: 0.75
        radius: 0
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
                property bool neo: neoWindow

                MouseArea {

                    anchors.fill: parent
                    hoverEnabled: true

                    onPressed: {
                        if (parent.neo) {
                            if (!parent.closer) {
                                Context.windowActive(winId)

                            } else {

                                for (var i = 0; i < winIds.length; i++) {
                                    Context.windowClose(winIds[i]);
                                }

                                fixShowInfos.visible = false
                            }
                        } else {
                            Context.exec(exec)
                            fixShowInfos.visible = false
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
        fixShowInfos.height = 30

        var y = 0

        for (var i = 0; i < winIds.length; i++) {

            nome = Context.windowName(winIds[i])

            if (nome.length >= 26) {
                nome = nome.substring(0, 20) + "..."
            }

            listModel.append({neoWindow: true, closerX: false, winId: winIds[i], rectY : y, name: nome, textY: y})

            if (i + 1 < winIds.length) {
                fixShowInfos.height += 30
                fixShowInfos.y -= 30
                y += 30
            }
        }

        if (winIds.length > 0) {

            showInfosBg.opacity = 0.75

            nome = winIds.length > 1 ? "Fechar Janelas X" : "Fechar X"

            fixShowInfos.height += 30
            fixShowInfos.y -= 30
            y += 30

            listModel.append({neoWindow: true, closerX: true, winId: 0, rectY : y, name: nome, textY: y})

            fixShowInfos.height += 30
            fixShowInfos.y -= 30
            y += 30

            listModel.append({neoWindow: false, closerX: true, winId: 0, rectY : y, name: "Abrir Nova", textY: y})

        } else {
            showInfosBg.opacity = 0.0
        }
    }
}
