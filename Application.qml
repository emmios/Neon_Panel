import QtQuick 2.7
import QtQuick.Controls 1.4
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
    //property int winId: 0
    //property string obclass: ""
    //property var destak: destak
    //property bool tooTip: true
    property alias destak: destak
    property alias effect: effect
    property alias bgOpc: bgOpc
    property bool destacad: false

    //signal create
    //signal destroy

    function create() {
        destak.visible = true
    }

    function destroy() {
        destak.visible = false
    }

    Rectangle {
        id: destak
        x: 0
        y: parent.height - 2
        height: 2
        width: parent.width
        color: main.detailColor//"#007fff"
        visible: true
        opacity: 0.8//0.5
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
        opacity: 0.0
    }

    Image {
        id: appIcon
        x: 12
        y: 8
        width: 24
        height: 24
        source: url
        fillMode: Image.PreserveAspectFit//Image.Stretch
        antialiasing: true
        cache: false
    }

    Label {
        x: 6
        y: 4
        text: "" //paperclip 
        color: "#fff"
        font.pixelSize: 6
        //transform: Rotation {angle: -25}
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
                //neonMenu.addApps()
                //main.clickOpc = main.startOpc

                if (!_instance) {
                    Context.exec(exec)
                    _instance = true

                } else {

                    if (!Context.isMinimized(pidname) & Context.isActive(pidname)) {

                        Context.manyMinimizes(pidname)
                        minimize = false;

                    } else {
                        Context.manyActives(pidname)
                        minimize = true;
                    }
                }

                activeWindow()

            } else {

                if (_instance) {
                    showAppInfo.winIds = Context.windowsBywmclass(pidname)
                    showAppInfo.y = main.y - 40
                    showAppInfo.x = ((Context.mouseX() - mouseX) + (applicationInfo.width / 2)) - (showAppInfo.width / 2)//Context.mouseX() - (showAppInfo.width / 2)
                    showAppInfo.setText()
                    showAppInfo.visible = true
                    showAppInfo.requestActivate()
                    //clickOpc = startOpc
                    neonMenu.textSearch.focus = false
                } else {
                    unfix.wmclass = pidname
                    unfix.y = main.y - 40
                    unfix.x = ((Context.mouseX() - mouseX) + (applicationInfo.width / 2)) - (showAppInfo.width / 2)//Context.mouseX() - (showAppInfo.width / 2)
                    unfix.visible = true
                    unfix.requestActivate()
                    //clickOpc = startOpc
                    neonMenu.textSearch.focus = false
                }
            }
        }


        hoverEnabled: true

        onHoveredChanged: {
            //bgOpc.opacity = 0.2//0.75
            effect.glowRadius = 3
            effect.opacity = 1
        }

        onExited: {
            if (destacad == false) {
                //bgOpc.opacity = 0
                effect.glowRadius = 0
                effect.opacity = 0
            }
        }

    }
}
