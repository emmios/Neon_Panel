import QtQuick 2.9
import QtQuick.Controls 1.4
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
        cache: false
    }

    MouseArea {

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {

            acessoRapido.visible = false
            acessoRapido.accessBlur.source = ""
            arrowAside.text = '\uf106'
            accessOpened = true
            neonMenu.visible = false

            if (mouse.button & Qt.LeftButton) {

                hasNotification.visible = false
                Context.execFromPid(pid)

            } else {

                trayShowInfo.pid = pid
                trayShowInfo.y = main.y - 55
                trayShowInfo.x = ((Context.mouseX() - mouseX) + (trayAppInfo.width / 2)) - (trayShowInfo.width / 2)
                trayShowInfo.visible = true
                trayShowInfo.requestActivate()

                neonMenu.textSearch.focus = false
            }
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
