import QtQuick 2.9
import QtQuick.Controls 2.2


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
        opacity: 0.80
        radius: 0
    }

    Timer {
        id: execDelay
        running: false
        interval: 100
        repeat: false
        onTriggered: {
            trayShowInfo.visible = false
            Context.execFromPid(pid)
        }
    }

    Timer {
        id: closeDelay
        running: false
        interval: 100
        repeat: false
        onTriggered: {
            trayShowInfo.visible = false
            Context.killFromPid(pid)
        }
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
                    execDelay.stop()
                    execDelay.start()
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
                    closeDelay.stop()
                    closeDelay.start()
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
