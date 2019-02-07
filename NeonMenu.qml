import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0


ApplicationWindow {
    id: neonMenu
    visible: false
    x: 0
    y: 0
    width: 470//530
    height: 530
    title: qsTr("Neon Menu")
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

    property var menuElements: []
    property var textSearch: textSearch
    property string textColor: "#fff"
    property alias blur: blur

    function addApps() {

        var x = 0
        var y = 0

        for (var i = 0; i < menuElements.length; i++) {

            menuElements[i].x = x
            menuElements[i].y = y

            x += 74

            if (x + 74 >= neonMenu.width) {
                x = 0
                y += 78
            }

            menuElements[i].visible = true
        }

        launchersApps.height = y;
    }


    onActiveChanged: {
        if (!active) {
            //neonMenu.close()
            textSearch.text = ""
            textSearch.focus = true
            neonMenu.visible = false
            main.clickOpc = main.startOpc
            textSearch.focus = false
            addApps()
            btnCycle.border.color = "#fff"
            blur.source = ""
            main.activeWindow()
        }
    }

    MouseArea {
        id: mouseMenu
        anchors.fill: parent

        onClicked: {

            addApps()
            textSearch.focus = false
            textSearch.text = "Buscar..."

            showAppInfo.visible = false
        }
    }

    Image {
        id: blur
        x: 0
        y: (~neonMenu.y) + 1
        width: Screen.width
        height: Screen.height //Screen.height - main.height
        source: "image://grab/crop"
        visible: false
        //clip: true
    }

    FastBlur {
        id: fastBlur
        anchors.fill: blur
        source: blur
        radius: 100
    }

    Blend {
        id: blend
        anchors.fill: fastBlur
        source: fastBlur
        foregroundSource: fastBlur
        mode: "softLight"
        opacity: 0.3//0.2
    }

    HueSaturation {
        id: saturation
        anchors.fill: blur
        source: fastBlur
        hue: 0
        saturation: 1
        lightness: 0
    }

    Image {
        id: overlay
        anchors.fill: blur
        source: "qrc:/Resources/noise.png"
        fillMode: Image.Tile
    }

    Blend {
        id: blend2
        anchors.fill: overlay
        source: overlay
        foregroundSource: saturation
        mode: "addition"
        opacity: 1
    }

    Rectangle {
        anchors.fill: blur
        opacity: 0.3//0.7//main.opc
        color: "#fff"//"#161616"
    }


    Rectangle {
        id: resize
        x: 470
        width: 18
        height: 18
        color: "#ffffff"
        opacity: 0.0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeAllCursor

            property int startX: 0
            property int startY: 0
            property bool btnUp: true

            /*
            onReleased: {
                neonMenu.width += mouseX
                neonMenu.height -= mouseY
                neonMenu.y += mouseY
            }
            */

            onPressedChanged: {
                if (btnUp) {

                    btnUp = false
                    startX = mouseX - 18
                    startY = mouseY

                } else {

                    btnUp = true
                    addApps()

                    textSearch.focus = false
                    textSearch.text = "Buscar..."
                }
            }

            onMouseXChanged: {
                neonMenu.width = Context.mouseX() - startX
                neonMenu.y = Context.mouseY() - startY
                neonMenu.height = main.y - neonMenu.y//(neonMenu.y + 5)
            }
        }
    }

    Rectangle {
        id: rectangleTop
        height: 80
        color: "#000000"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        opacity: 0.0

//        Rectangle {
//            id:topDestak
//            width: parent.width
//            height: 2
//            color: main.detailColor
//            anchors.topMargin: 0
//            anchors.leftMargin: 0
//            anchors.rightMargin: 0
//            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.right: parent.right
//        }

//        Rectangle {
//            id: bottomDestak
//            width: parent.width
//            height: 2
//            color: main.detailColor
//            anchors.topMargin: 0
//            anchors.leftMargin: 0
//            anchors.rightMargin: 0
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
//            anchors.right: parent.right
//        }
    }

    Rectangle {
        id: subMask
        width: 52
        height: 52
        antialiasing: true
        anchors.left: parent.left
        anchors.leftMargin: 22
        anchors.top: parent.top
        anchors.topMargin: 14
        visible: true
        radius: 33
        color: main.detailColor

        Rectangle {
            id: mask
            width: 52
            height: 52
            antialiasing: true
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.top: parent.top
            anchors.topMargin: 16
            visible: false
            radius: 32
        }
    }

    Image {
        id: image
        width: 48
        height: 48
        antialiasing: true
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 16
        source: "file://" + Context.basepath + "/01.jpg"

        fillMode: Image.PreserveAspectCrop
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: mask
        }
    }

    Rectangle {
        id: rectangle2
        x: 0
        y: 436
        height: 50
        color: "transparent"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.left: parent.left
        opacity: 1
        anchors.right: parent.right
        anchors.leftMargin: 0

        Rectangle {
            id: search
            color: "#333"
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.top: parent.top
            anchors.topMargin: 12
            opacity: 0.5
        }
    }

    TextInput {
        id: textSearch
        x: 0
        y: 410
        height: 30
        color: "#fff"
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        text: ""
        antialiasing: true
        //cursorVisible: true
        focus: true
        font.bold: false
        font.pointSize: 12
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        selectionColor: main.detailColor
        selectByMouse: true
        wrapMode: TextEdit.Wrap

        onFocusChanged: {
            text = ""
        }

        Keys.onReleased: {

            var x = 0
            var y = 0

            for (var i = 0; i < menuElements.length; i++) {

                if(menuElements[i].nome.toLowerCase().search(text.toLowerCase()) !== -1) {

                    menuElements[i].x = x
                    menuElements[i].y = y

                    x += 74

                    if (x + 74 >= neonMenu.width) {
                        x = 0
                        y += 78
                    }

                    menuElements[i].visible = true

                } else {
                    menuElements[i].visible = false
                }
            }

            launchersApps.height = y;
        }
    }

    Text {
        id: text1
        width: 149
        height: 14
        text: Context.userName() //qsTr("SHENOISZ")
        anchors.left: parent.left
        anchors.leftMargin: 90
        anchors.top: parent.top
        anchors.topMargin: 33
        font.bold: false
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
        font.family: "roboto light"
        color: textColor
    }

    ScrollView {
        id: scrollview1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 80
        antialiasing: true
        highlightOnFocus: true
        frameVisible: false

//        Rectangle {
//            anchors.fill: parent
//            color: "#fff"
//        }

        Item {
            id: launchersApps
            height: 338
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

    }

    Rectangle {
        id: rectangle3
        x: 450
        y: 30
        width: 18
        height: 14
        color: "transparent"
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.right: parent.right
        anchors.rightMargin: 34
        visible: false

        Rectangle {
            id: rectangle4
            width: 18
            height: 2
            color: textColor
        }

        Rectangle {
            id: rectangle5
            x: 0
            y: 6
            width: 18
            height: 2
            color: textColor
        }

        Rectangle {
            id: rectangle6
            x: 0
            y: 12
            width: 18
            height: 2
            color: textColor
        }
    }

    Component.onCompleted: {

        var apps = Context.applications()
        var comp = Qt.createComponent("app.qml")
        var x = 0
        var y = 0

        for (var i = 0; i < apps.length; i ++) {

            var app = apps[i].split(';')

            if (app[0] !== "" & app[1] !== "") {

                var obj = comp.createObject(launchersApps, {'x': x, 'y': y, 'nome': app[0], 'icone': app[1], 'exec': app[2], 'launcherApp': 'file://' + app[3]})

                if (obj.icone !== "file://") {

                    obj.iconOpc = 0.0
                    menuElements.push(obj)

                    x += 74

                    if (x + 74 >= neonMenu.width) {
                        x = 0
                        y += 78
                    }
                } else {

                    obj.destroy()
                }
            }
        }

        launchersApps.height = y;
    }
}
