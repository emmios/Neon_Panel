import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0


Rectangle {
    id: trayAppInfo
    x: 0
    y: 0
    width: 28
    height: 40
    color: "transparent"

    property int winId: 0
    property string name: ""
    property string wclass: ""
    property string pid: ""

    property alias hasNotification: hasNotification

    Image {
        id: appIcon
        y: ((parent.height / 2) - (height / 2)) + 1
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.right: parent.right
        anchors.rightMargin: 6
        height: 16
        source: "image://pixmap/" + winId + ';' + wclass
        fillMode: Image.Stretch//Image.PreserveAspectCrop
        antialiasing: true
        smooth: true
        cache: false
    }

    Timer {
        id: execDelay
        running: false
        interval: 100
        repeat: false
        onTriggered: {
            hasNotification.visible = false
            Context.execFromPid(pid)
        }
    }

    ToolTip {
        id: toolTip
        x: 44
        text: name
        delay: 500
        timeout: 3000
        visible: false

        property bool timeActive: false
        property alias timer: timer

        contentItem: Label {
            text: toolTip.text
            wrapMode: Text.WordWrap
            font: toolTip.font
            color: "#ffffff"
        }

        background: Rectangle {
            opacity: 0.9
            color: main.detailInfoColor
        }

        Timer {
            id: timer
            running: false
            interval: 1000
            repeat: false
            onTriggered: {
                if (toolTip.timeActive) {
                    toolTip.visible = true
                }
            }
        }
    }

    MouseArea {

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            //acessoRapido.visible = false
            //acessoRapido.accessBlur.source = ""
            main.arrowAside.text = '\uf106'
            main.accessOpened = true
            //neonMenu.visible = false
            neonMenu.textSearch.focus = false
            main.menuOpened = true
            neonMenu.desactive()

            if (mouse.button & Qt.LeftButton) {
                execDelay.stop()
                execDelay.start()
            } else {
                trayShowInfo.pid = pid
                trayShowInfo.y = main.y - 55
                trayShowInfo.x = ((Context.mouseX() - mouseX) + (trayAppInfo.width / 2)) - (trayShowInfo.width / 2)
                trayShowInfo.visible = true
                trayShowInfo.requestActivate()
                neonMenu.textSearch.focus = false
            }
        }

        hoverEnabled: true

        onHoveredChanged: {
            toolTip.timeActive = true
            toolTip.timer.stop()
            toolTip.timer.start()
        }

        onExited: {
            toolTip.visible = false
            toolTip.timeActive = false
        }
    }

    Rectangle {
        id: hasNotification
        x: (trayAppInfo.width / 2) + 2
        y: (trayAppInfo.height / 2) + 4
        width: 6
        height: 6
        color: "#f00"
        radius: 3
        visible: false
    }
}
