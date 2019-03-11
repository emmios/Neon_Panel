import QtQuick 2.9
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0


Rectangle {
    id: applicationInfo
    width: main.defaultWidth
    height: 40
    color: "transparent"

    property string nome: ""
    property string pidname: ""
    property string obclass: ""
    property bool minimize: true
    property bool tooTip: true
    property int winId: 0
    property int pid: 0
    property alias destak: destak
    property alias effect: effect
    property alias bgOpc: bgOpc
    property bool destacad: false

    Rectangle {
        id: destak
        x: 1
        y: parent.height - 3
        height: 3
        width: parent.width - 2
        color: main.detailColor//"#007fff"
        visible: true
        opacity: 0.5//0.5
    }

    RectangularGlow {
        id: effect
        anchors.fill: destak
        glowRadius: 0
        spread: 0
        color: main.detailColor
        cornerRadius: destak.radius + glowRadius
    }

    Rectangle {
        id: bgOpc
        anchors.fill: parent
        color: main.detailColor//"#ffffff"
        opacity: 0.0
    }

    Image {
        id: appIcon
        x: 12
        y: 8
        width: 24
        height: 24
        source: "image://pixmap/" + winId + ';' + obclass + ',' + pidname
        fillMode: Image.PreserveAspectFit//Image.Stretch
        antialiasing: true
        smooth: true
        cache: false
        //transform: Rotation {angle: -20}
    }

    MouseArea {

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: {

            acessoRapido.visible = false
            acessoRapido.accessBlur.source = ""
            arrowAside.text = '\uf106'
            accessOpened = true
            neonMenu.visible = false

            if (mouse.button & Qt.LeftButton) {

                showAppInfo.visible = false

                neonMenu.textSearch.focus = false
                neonMenu.addApps()
                //main.clickOpc = main.startOpc

                if (!Context.isMinimized(pidname) & Context.isActive(pidname)) {

                    Context.manyMinimizes(pidname)
                    minimize = false;

                } else {

                    Context.manyActives(pidname)
                    minimize = true;
                }

               activeWindow()

            } else {

                main.showAppInfo.winIds = Context.windowsBywmclass(pidname)
                main.showAppInfo.y = main.y - 40
                main.showAppInfo.x = ((Context.mouseX() - mouseX) + (applicationInfo.width / 2)) - (main.showAppInfo.width / 2)
                main.showAppInfo.setText()
                main.showAppInfo.visible = true
                main.showAppInfo.requestActivate()
                //clickOpc = startOpc
                main.neonMenu.textSearch.focus = false
            }
        }

        hoverEnabled: true

        onHoveredChanged: {
            //bgOpc.opacity = 0.2//0.75
            effect.glowRadius = 4
            effect.opacity = 0.8
            destak.opacity = 0.5
        }

        onExited: {
            if (destacad == false) {
                //bgOpc.opacity = 0
                effect.glowRadius = 0
                effect.opacity = 0
                destak.opacity = 0.5
            }
        }
    }
}
