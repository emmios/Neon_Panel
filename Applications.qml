import QtQuick 2.9
import QtQuick.Controls 2.2
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

    ToolTip {
        id: toolTip
        x: 44
        text: nome
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
            color: "#000000"
        }

        Timer {
            id: timer
            running: false
            interval: 2000
            repeat: false
            onTriggered: {
                if (toolTip.timeActive) {
                    toolTip.visible = true
                }
            }
        }
    }

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
        //rotation: -5
        //transform: Rotation {angle: -20}
    }

    Timer {
        id: minimizeDelay
        running: false
        interval: 100
        repeat: false
        onTriggered: {
            if (!Context.isMinimized(pidname) & Context.isActive(pidname)) {
                Context.manyMinimizes(pidname)
                minimize = false;
            } else {
                Context.manyActives(pidname)
                minimize = true;
            }

           activeWindow()
        }
    }

    MouseArea {

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: {

            //acessoRapido.visible = false
            //acessoRapido.accessBlur.source = ""
            main.arrowAside.text = '\uf106'
            main.accessOpened = true
            //neonMenu.visible = false
            neonMenu.textSearch.focus = false
            main.menuOpened = true
            neonMenu.desactive()

            if (mouse.button & Qt.LeftButton) {

                showAppInfo.visible = false

                neonMenu.textSearch.focus = false
                //neonMenu.addApps()
                //main.clickOpc = main.startOpc
                minimizeDelay.stop()
                minimizeDelay.start()

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

            toolTip.timeActive = true
            toolTip.timer.stop()
            toolTip.timer.start()
        }

        onExited: {
            if (destacad == false) {
                //bgOpc.opacity = 0
                effect.glowRadius = 0
                effect.opacity = 0
                destak.opacity = 0.5
            }

            toolTip.visible = false
            toolTip.timeActive = false
        }
    }
}
