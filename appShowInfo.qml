import QtQuick 2.9
import QtQuick.Controls 1.4


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
            //showAppInfo.close()
            showAppInfo.visible = false
            showInfos.winIds = []
            listModel.clear()
        } else {
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

                MouseArea {

                    anchors.fill: parent
                    hoverEnabled: true

                    onPressed: {

                        if (!parent.closer) {
                            Context.windowActive(winId)

                        } else {

                             for (var i = 0; i < winIds.length; i++) {
                                Context.windowClose(winIds[i]);
                             }

                             //showAppInfo.close()
                             showAppInfo.visible = false
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
                    //font.bold: true
                    font.pixelSize: 12
                    color: "#ffffff"
                    text: name
                }
        }
    }

    function setText() {

        listModel.clear()
        //showInfos.y = main.y - 40
        showInfos.height = 30
        //showInfos.width = 0

        var y = 0
        //var nome, size, pos

        for (var i = 0; i < winIds.length; i++) {

            nome = Context.windowName(winIds[i])
            //size = nome.length < 16 ?  nome.length * 10 : nome.length * 6.6

            if (nome.length >= 26) {
                nome = nome.substring(0, 20) + "..."
            }

            listModel.append({closerX: false, winId: winIds[i], rectY : y, name: nome, textY: y})

//            if (showInfos.width < size) {
//                //showInfos.width = size
//                pos = Context.mouseX() - (showInfos.width / 2)
//                showInfos.x = pos < 0 ? 0 : pos
//            }

            if (i + 1 < winIds.length) {
                showInfos.height += 30
                showInfos.y -= 30
                y += 30
            }
        }

        if (winIds.length > 0) {

            showInfosBg.opacity = 0.75

            nome = winIds.length > 1 ? "Fechar Todas X" : "Fechar X"
            //size = nome.length < 16 ?  nome.length * 10 : nome.length * 6.6

            showInfos.height += 30
            showInfos.y -= 30
            y += 30

            listModel.append({closerX: true, winId: 0, rectY : y, name: nome, textY: y})

//            if (showInfos.width < size) {
//                //showInfos.width = size
//                pos = Context.mouseX() - (showInfos.width / 2)
//                showInfos.x = pos < 0 ? 0 : pos
//            }

        } else {
            showInfosBg.opacity = 0.0
        }
    }
}
