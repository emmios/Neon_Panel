import QtQuick 2.9
import QtQuick.Controls 2.2


ApplicationWindow {
    id: unfix
    x: 10
    y: 10
    width: 160
    height: 60
    color: "transparent"
    title: qsTr("Neon Painel")
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Popup

    property string wmclass: ""
    property alias listView: listView


    onActiveChanged: {
        if (!active) {
            unfix.visible = false
        } else {
            main.showAppInfo.visible = false
            main.fixShowInfos.visible = false
        }
    }

    Rectangle {
        id: showInfosBg
        anchors.fill: parent
        color: "#000000"
        opacity: 0.80
        radius: 0
    }

    ListView {
        id: listView
        x: 0
        y: 0
        anchors.fill: parent

        model: ListModel {
            id: listModel

            ListElement {
                name: "Unknow"
                posy: 0
            }

            ListElement {
                name: "Remover "
                posy: 30
            }
        }
        delegate: Item {
            x: 0
            y: 0
            anchors.fill: parent

            Rectangle {
                x: 0
                y: posy
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: 30
                color: "transparent"

                MouseArea {

                    anchors.fill: parent
                    hoverEnabled: true

                    onPressed: {
                        unfix.visible = false
                        var appTmp = []

                        for (var k = 0; k < main.applicationBar.children.length; k++) {
                            if (typeof(main.applicationBar.children[k]) !== "undefined") {
                                if (main.applicationBar.children[k].pidname === wmclass) {
                                    delete main.applicationBar.children[k]
                                } else {
                                    appTmp.push(main.applicationBar.children[k])
                                }
                            }
                        }

                        main.applicationBar.children = appTmp
                        main.launcherX = 0
                        main.applicationBar.width = 0

                        for (var i = 0; i < main.applicationBar.children.length; i++) {
                            if (typeof(main.applicationBar.children[i]) !== "undefined") {
                                main.applicationBar.width += main.defaultWidth
                                main.applicationBar.children[i].x = main.launcherX
                                main.launcherX += main.defaultWidth
                            }
                        }

                        main.subAppbar.x -= main.defaultWidth
                        main.subAppbar.width -= main.defaultWidth
                        main.createWindow(Context.getAllWindows())
                        Context.fixedLauncher(wmclass, "", 1)
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
                y: posy
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: 30
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
                color: "#ffffff"
                text: name

                function setName(arg) {
                    if (index == 0) {
                        text = (arg.length >= 26) ? arg.substring(0, 20) + "..." : arg
                    }
                }
            }
        }
    }
}
