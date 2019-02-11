import QtQuick 2.9
import QtQuick.Controls 1.4


ApplicationWindow {

    id: trayShowInfo
    x: 10
    y: 10
    width: 80
    height: 50
    color: "transparent"
    title: qsTr("Neon Painel")
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

    property string pid: ""

    onActiveChanged: {
        if (!active) {
            //showAppInfo.close()
            trayShowInfo.visible = false
        }
    }

    Rectangle {
        id: showInfosBg
        anchors.fill: parent
        color: "#000000"
        opacity: 0.75
        radius: 0
    }

    Item {
        x: 0
        y: 0
        anchors.fill: parent

        Rectangle {
            x: 0
            y: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height: 25
            color: "transparent"

            MouseArea {

                anchors.fill: parent
                hoverEnabled: true

                onPressed: {
                    trayShowInfo.visible = false
                    Context.execFromPid(pid)
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
            y: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height: 25
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            //font.bold: true
            font.pixelSize: 12
            color: "#ffffff"
            text: "Restaurar"
        }

        Rectangle {
            x: 0
            y: 25
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height: 25
            color: "transparent"

            MouseArea {

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    trayShowInfo.visible = false
                    Context.killFromPid(pid)
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
            y: 25
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            height: 25
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            //font.bold: true
            font.pixelSize: 12
            color: "#ffffff"
            text: "Sair"
        }

    }
}
