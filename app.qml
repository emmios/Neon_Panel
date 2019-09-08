import QtQuick 2.9
import QtQuick.Controls 2.2


Rectangle {
    id: rectangle
    x: 0
    y: 0
    width: 74
    height: 78
    color: "transparent"

    property string icone: ""
    property string nome: ""
    property string exec: ""
    property string launcherApp: ""
    property double iconOpc: 0.0
    property alias bg: bg

    Rectangle {
        id: bg
        anchors.fill: parent
        color: main.detailColor//"#ffffff"
        opacity: 0 //iconOpc
        radius: 3

        MouseArea {

            id: mouseArea
            width: 70
            anchors.fill: parent
            //drag.target: iconeApp

            property bool _pressed: false
            property bool _pressed2: false
            property int mouseStart: 0

//            onClicked: {

//                Context.exec(exec, launcherApp)

//                neonMenu.visible = false
//                neonMenu.textSearch.focus = false
//                main.clickOpc = main.startOpc
//            }

            onPressedChanged: {

                if (_pressed2) {
                    //neonMenu.visible = false
                    neonMenu.textSearch.focus = false
                    main.menuOpened = true
                    neonMenu.desactive()
                    main.clickOpc = main.startOpc
                    Context.exec(exec, launcherApp)
                }

                if (!_pressed) {
                    _pressed = true
                    _pressed2 = true
                    mouseStart = mouseX
                } else {
                    _pressed = false
                    _pressed2 = false
                    mouseStart = mouseX
                    parent.opacity = 0.0
                    main.clickOpc = main.startOpc
                    //neonMenu.visible = false
                    neonMenu.textSearch.focus = false
                    main.menuOpened = true
                    neonMenu.desactive()
                    neonMenu.addApps()
                }
            }

            onMouseXChanged: {

                if (_pressed2 && mouseX > mouseStart + 10) {
                    _pressed2 = false
                    Context.dragDrop(icone.replace("file://", ""), launcherApp)
                    //neonMenu.visible = false
                    neonMenu.textSearch.focus = false
                    main.menuOpened = true
                    neonMenu.desactive()
                    neonMenu.addApps()
                }
                //neonMenu.visible = true
                //neonMenu.requestActivate()
            }

            hoverEnabled: true

            onHoveredChanged: {
                parent.opacity = 0.75
                toolTip.visible = true
            }

            onExited: {
                parent.opacity = 0.0
                toolTip.visible = false
            }

        }
    }

    Image {
        id: iconeApp
        x: 12
        y: 1
        width: 48
        height: 48
        source: icone
        antialiasing: true
        smooth: true
        //rotation: -5
        fillMode: Image.PreserveAspectCrop

        ToolTip {
            id: toolTip
            text: nome
            delay: 500
            timeout: 5000
            visible: false
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
        }
   }

   Text {
        id: name
        y: 42
        height: 8
        text: nome.length < 9 ? nome : nome.substring(0, 9) + '...'
        font.pointSize: 8
        wrapMode: Text.NoWrap
        anchors.right: parent.right
        anchors.rightMargin: 7
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: textColor
        font.family: main.fontName
   }
}
