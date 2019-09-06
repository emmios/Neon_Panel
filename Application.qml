import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0


Rectangle {
    id: applicationInfo
    width: main.defaultWidth
    height: 40
    color: "transparent"

    property string url: ""
    property string nome: ""
    property string exec: ""
    property bool _instance: false
    property string pidname: ""
    property bool minimize: true
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
        opacity: 0//0.5//0.5
    }

    RectangularGlow {
        id: effect
        anchors.fill: destak
        glowRadius: 0
        spread: 0
        color: main.detailColor
        cornerRadius: destak.radius + glowRadius
        opacity: 0
    }

    Rectangle {
        id: bgOpc
        anchors.fill: parent
        color: main.detailColor//"#ffffff"
        opacity: 0
    }

    Image {
        id: appIcon
        x: 12
        y: 8
        width: 24
        height: 24
        source: Context.crop(url) //"image://pixmap/" + url //url
        fillMode: Image.PreserveAspectFit//Image.Stretch
        antialiasing: true
        smooth: true
        cache: false
        //rotation: -5
        //transform: Rotation {angle: -20}
    }

    PropertyAnimation {id: ani; target: effect; property: "opacity"; to: 0.5; duration: 300}

/*
    Image {
        x: 4
        y: 8
        width: 4
        height: 6//8
        antialiasing: true
        cache: false
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Resources/thumbtack.svg"
        transform: Rotation {angle: -42}
    }
*/


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

                if (!_instance) {
                    Context.exec(exec)
                    _instance = true
                    activeWindow()

                } else {
                    minimizeDelay.stop()
                    minimizeDelay.start()
                }

            } else {

                if (_instance) {
                    main.fixShowInfos.winIds = Context.windowsBywmclass(pidname)
                    main.fixShowInfos.exec = exec
                    main.fixShowInfos.y = main.y - 40
                    main.fixShowInfos.x = ((Context.mouseX() - mouseX) + (applicationInfo.width / 2)) - (main.fixShowInfos.width / 2)//Context.mouseX() - (showAppInfo.width / 2)
                    main.fixShowInfos.setText()
                    main.fixShowInfos.visible = true
                    main.fixShowInfos.requestActivate()
                    //clickOpc = startOpc
                    main.neonMenu.textSearch.focus = false
                } else {
                    main.unfix.wmclass = pidname
                    main.unfix.listView.contentItem.children[0].children[1].setName(nome)
                    main.unfix.y = main.y - 70
                    main.unfix.x = ((Context.mouseX() - mouseX) + (applicationInfo.width / 2)) - (main.fixShowInfos.width / 2)//Context.mouseX() - (showAppInfo.width / 2)
                    main.unfix.visible = true
                    main.unfix.requestActivate()
                    //clickOpc = startOpc
                    main.neonMenu.textSearch.focus = false
                }
            }
        }


        hoverEnabled: true

        onHoveredChanged: {
            if (_instance) {
                effect.glowRadius = 4
                //effect.opacity = 0.8
                destak.opacity = 0.3
                ani.to = 0.8
                ani.stop()
                ani.start()
            } else {
                //effect.opacity = 0.5
                effect.glowRadius = 0
                destak.opacity = 0
                ani.to = 0.5
                ani.stop()
                ani.start()
            }

            toolTip.timeActive = true
            toolTip.timer.stop()
            toolTip.timer.start()
        }

        onExited: {
            if (destacad == false) {
                effect.glowRadius = 0
                //effect.opacity = 0
                ani.to = 0.0
                ani.stop()
                ani.start()

                if (_instance) {
                    destak.opacity = 0.3
                } else {
                    destak.opacity = 0
                }
            }

            toolTip.visible = false
            toolTip.timeActive = false
        }
    }

    on_InstanceChanged: {
        if (_instance) {
            destak.opacity = 0.5
        } else {
            destak.opacity = 0
        }
    }
}
