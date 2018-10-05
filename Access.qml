import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.4
import "qrc:/Components"


ApplicationWindow {
    id: acessoRapido
    visible: false
    x: main.width - 249
    y: 0//main.y - 310//(310 + 5)
    width: 250
    height: Screen.height//main.y
    title: qsTr("Neon Painel")
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    property var acessText: acessText
    property string accessDetail: "#fff"
    property alias accessBlur: blur

    onActiveChanged: {
        if (!active) {
            acessoRapido.visible = false
            blur.source = ""
            arrowAside.text = '\uf106'
            accessOpened = true
            wifiInfo.visible = false
            wifiList.model = ContextPlugin.redes().split(";")
        }
    }

    Image {
        id: blur
        x: (~(Screen.width - acessoRapido.width))
        y: 0
        source: "image://grab/crop"
        clip: true
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
        opacity: 0.2
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
        opacity: 0.7//main.opc
        color: "#161616"
    }

    Rectangle {
        id: acessUser
        x: 0
        y: 0
        width: parent.width
        height: 70
        color: "transparent"

        Rectangle {
            id: subMask
            x: (parent.width / 2) - (52 / 2)
            y: 2
            width: 66
            height: 66
            antialiasing: true
            visible: true
            radius: 33
            color: main.detailColor

            Rectangle {
                id: mask
                width: 66
                height: 66
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
            x: (parent.width / 2) - (48 / 2)
            y: 4
            width: 62
            height: 62
            antialiasing: true
            source: "file://" + Context.basepath + "/01.jpg"

            fillMode: Image.PreserveAspectCrop
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: mask
            }
        }
    }

    Rectangle {
        id: primaryPlugins
        x: 0
        y: 70
        width: parent.width
        height: 50
        color: "transparent"

        Text {
            id: acessText
            x: 22
            y: 8
            text: "Access Speed"
            width: (parent.width / 2) - x
            height: parent.height - y
            color: accessDetail
            font.pixelSize: 23
            font.bold: false
            font.family: "roboto light"
        }
    }

    Rectangle {
        id: dinamicContent
        x: 0
        y: primaryPlugins.y + primaryPlugins.height
        width: parent.width
        height: parent.height - (pluginItemsAdd.height + controls.height + 120)
        color: "transparent"//"#f93"

        Item {
            id: display
            visible: false
            anchors.fill: parent
            ScrollView {
                width: display.width
                height: 400
                Repeater {
                    model: 3
                    Rectangle {
                        color: "#f93"
                        width: display.width
                        height: 50
                        y: 0

                        Component.onCompleted: {
                            y = 52 * index
                        }
                    }
                }
            }
        }

        Calendar {
            id: pluginCalendar
            visible: false
            anchors.fill: parent
            style: CalendarStyle {
                gridVisible: false
            }
        }

        Item {
            id: pluginWifi
            visible: false
            anchors.fill: parent
            Rectangle {
                y: 0
                color: "transparent"
                width: parent.width
                height: 30

                Rectangle {
                    anchors.fill: parent
                    color: "#fff"
                    opacity: 0.1
                }

                Label {
                    y: 10
                    x: 20
                    text:"Atualizar"
                    color: "#fff"
                    font.pixelSize: 10
                    font.family: "Font Awesome 5 Free"
                }

                Label {
                    y: 8
                    x: parent.width - 30
                    text:"\uf2f1"
                    color: "#fff"
                    font.pixelSize: 14
                    font.family: "Font Awesome 5 Free"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        wifiList.model = []
                        wifiInfo.visible = false
                        waitLoading.visible = true
                        ContextPlugin.scan()
                        _loading.stop()
                        _loading.start()
                    }
                }

                Timer {
                    id: _loading
                    running: true
                    interval: 5000
                    repeat: false
                    onTriggered: {
                        if (ContextPlugin.checkIfWirelessConnecting().toString() == "false") {
                            wifiList.model = ContextPlugin.redes().split(";")
                            waitLoading.visible = false
                            _loading.stop()
                        }
                    }
                }
            }

            ScrollView {
                id: wifi
                x: 0
                y: 32
                width: parent.width
                height: parent.height - 52
                antialiasing: true
                highlightOnFocus: true
                frameVisible: false
                Item {
                    id: lista
                    width: parent.width
                    property var rede

                    Repeater {
                        id: wifiList
                        //model: [["#0f0", "Internet 1"], ["#0f0", "Internet 2"], ["#0f0", "Internet 3"], ["#ff9933", "Internet 4"], ["#ff9933", "Internet 5"], ["#f00", "Internet 6"], ["#f00", "Internet 7"]]
                        model: ContextPlugin.redes().split(";")
                        Rectangle {
                            id: wiFi
                            y: 52 * index
                            color: "transparent"
                            width: wifi.width
                            height: 50

                            Rectangle {
                                anchors.fill: parent
                                color: "#fff"
                                opacity: (ContextPlugin.getCurrentNetwork() == modelData.split(',')[1]) ? 0.3 : 0.1
                            }

                            // wifi icon
                            Label {
                                x: 20
                                y: 14
                                text: "\uf1eb"
                                color: (modelData.split(',')[4] > 85) ? "#0f0" : (modelData.split(',')[4] > 65) ? "#30FF35" : (modelData.split(',')[4] > 45) ? "#70FF75" : (modelData.split(',')[4] > 25) ? "#AAFFAD" : "#DAFFDE"
                                font.pixelSize: 24
                                font.family: "Font Awesome 5 Free"
                            }

                            // wifi name
                            Label {
                                anchors.centerIn: parent
                                y: 9
                                text: ((modelData.split(',')[1].toString().length < 15) ? modelData.split(',')[1] : modelData.split(',')[1].substring(0, 13) + '...')
                                color: "#fff"
                                font.pixelSize: 14
                                font.family: "Font Awesome 5 Free"
                            }

                            // password or not password
                            Label {
                                y: 25
                                x: 22
                                text: (modelData.split(',')[3]) ? '\uf023' : ""
                                color: "#fff"
                                font.pixelSize: 8
                                font.family: "Font Awesome 5 Free"
                            }

                            // current network
                            Label {
                                y: 31
                                x: 42
                                text: (ContextPlugin.getCurrentNetwork() == modelData.split(',')[1]) ? '\uf058' : ""
                                color: "#fff"
                                font.pixelSize: 10
                                font.family: "Font Awesome 5 Free"
                            }

                            // intencidade
                            Label {
                                y: 12
                                x: 48
                                text: modelData.split(',')[4]
                                color: "#fff"
                                font.pixelSize: 6
                                font.family: "Font Awesome 5 Free"
                            }

                            MouseArea {
                                id: mouseFi
                                anchors.fill: parent

                                onClicked: {
    //                              camada.width = 0
    //                              ani.stop()
    //                              ani.to = parent.width
    //                              ani.start()

                                    var current = (ContextPlugin.getCurrentNetwork() == modelData.split(',')[1]) ? true : false

                                    wifiInfo.index = modelData.split(',')[0]
                                    wifiInfo.rede = modelData.split(',')[1]
                                    wifiInfo.enc = modelData.split(',')[5]
                                    wifiInfo.canal = modelData.split(',')[6]
                                    wifiInfo.intenc = modelData.split(',')[4]
                                    wifiInfo.input.text = ""
                                    wifiInfo.input.focus = false
                                    wifiInfo.ip = (current) ? ContextPlugin.getWirelessIP() : ""
                                    wifiInfo.nameIp = (current) ? true : false
                                    wifiInfo.password = modelData.split(',')[7]

                                    if (current) {
                                        wifiInfo.hasPassword = false
                                    } else {
                                        if (modelData.split(',')[3]) {
                                            wifiInfo.hasPassword = (modelData.split(',')[7] == '') ? true : false
                                        }
                                    }

                                    wifiInfo.btnText = (current) ? "Desconectar" : "Conectar"
                                    wifiInfo.visible = true

                                    wifiList.model = []
                                }
                            }

                            Rectangle {
                                id: camada
                                y: 0
                                x: 0
                                color: "transparent"
                                width: 0
                                height: 50
                                clip: true

                                FocusScope {
                                    id: focused
                                    anchors.fill: parent
                                    focus: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        focused.focus = true
                                        ani.stop()
                                        ani.to = 0
                                        ani.start()
                                    }
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#fff"
                                    opacity: 0.8
                                }

                                TextField {
                                    x: parent.width - 240
                                    y: 10
                                    text: ""
                                    width: 140
                                    height: 30
                                    textColor: "#333"
                                    bg.color: "#fff"
                                    bg.opacity: 0.8
                                    maxLength: 30
                                    size: 14
                                    detailColor: main.detailColor
                                    visible: (modelData.split(',')[7] == '') ?  true : false
                                }

                                Rectangle {
                                    id: btnConnect
                                    x: parent.width - 92
                                    y: 10
                                    width: 82
                                    height: 30
                                    color: main.detailColor
                                    opacity: 0.8
                                    border {width: 1; color: "#aaa"}

                                    Label {
                                        id: connect
                                        anchors.centerIn: parent
                                        text: "Conectar"
                                        color: "#fff"
                                        size: 12
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (ContextPlugin.getCurrentNetwork() == modelData.split(',')[1]) {
                                                ContextPlugin.disconnectWireless()
                                                connect.text = "Conectar"
                                            } else {
    //                                            if ((modelData.split(',')[7] != '')) {
    //                                                ContextPlugin.setWirelessProperty(modelData.split(',')[0], 'key', modelData.split(',')[7])
    //                                            }
                                                ContextPlugin.connectWireless(modelData.split(',')[0])
                                                connect.text = "Desconectar"
                                            }

                                            waitLoading.visible = true
                                            loading.stop()
                                            loading.start()
                                            wifiList.model = []
                                        }
                                    }
                                }
                            }

                            PropertyAnimation {id: ani; target: camada; property: "width"; to: parent.width; duration: 300}

                            Component.onCompleted: {

                                lista.height = 52 * index
                                //lista.height += 52

                                var current = ContextPlugin.getCurrentNetwork()

                                if (current == modelData.split(',')[1]) {
                                    connect.text = "Desconectar"
                                }
                            }
                        }
                    }

                    Timer {
                        id: loading
                        running: true
                        interval: 1000
                        repeat: true
                        onTriggered: {
                            if (ContextPlugin.checkIfWirelessConnecting().toString() == "false") {
                                wifiList.model = ContextPlugin.redes().split(";")
                                waitLoading.visible = false
                                loading.stop()
    //                            if (rede.active) {
    //                                ContextPlugin.setWirelessProperty(rede.number, 'key', rede.key)
    //                            }
                            }
                        }
                    }

                    Rectangle {
                        id: waitLoading
                        width: animation.width
                        height: animation.height
                        color: "transparent"
                        opacity: 1
                        visible: true
                        antialiasing: true
                        AnimatedImage { id: animation; antialiasing: true; x: -2; source: "qrc:/Resources/wating.gif"}
                    }

    //                Component.onCompleted: {
    //                    wifiList.model = []
    //                }
                }

                Rectangle {
                    id: wifiInfo
                    y: 0
                    width: wifi.width - 2
                    height: wifi.height - 2
                    color: "transparent"
                    visible: false

                    property int index: 0
                    property string password: ''
                    property alias rede: infoRede.text
                    property alias enc: infoEnc.text
                    property alias canal: infoCanal.text
                    property alias intenc: infoInt.text
                    property alias input: password.input
                    property alias ip: infoIp.text
                    property alias nameIp: nameIp.visible
                    property alias hasPassword: addPassword.visible
                    property alias btnText: btnText.text

                    Rectangle {
                        anchors.fill: parent
                        color: "#fff"
                        opacity: 0.2
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                password.input.focus = false
                            }
                        }
                    }

                    Label {
                        id: infoRede
                        y: 40
                        x: 20
                        text: ""
                        color: "#fff"
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        y: 70
                        x: 20
                        text: "Segurança:"
                        color: "#fff"
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        id: infoEnc
                        y: 90
                        x: 20
                        text: ""
                        color: "#fff"
                        font.bold: true
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        y: 110
                        x: 20
                        text: "Canal:"
                        color: "#fff"
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        id: infoCanal
                        y: 130
                        x: 20
                        text: ""
                        color: "#fff"
                        font.bold: true
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        y: 150
                        x: 20
                        text: "Potência do sinal:"
                        color: "#fff"
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        id: infoInt
                        y: 170
                        x: 20
                        text: ""
                        color: "#fff"
                        font.bold: true
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        id: nameIp
                        y: 190
                        x: 20
                        text: "IP:"
                        color: "#fff"
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Label {
                        id: infoIp
                        y: 210
                        x: 20
                        text: ""
                        color: "#fff"
                        font.bold: true
                        font.pixelSize: 14
                        font.family: "Font Awesome 5 Free"
                    }

                    Rectangle {
                        id: addPassword
                        y: 230
                        x: 20
                        color: "transparent"

                        Label {
                            y: 0
                            x: 0
                            text: "Senha:"
                            color: "#fff"
                            font.pixelSize: 14
                            font.family: "Font Awesome 5 Free"
                        }

                        TextField {
                            id: password
                            x: 0
                            y: 20
                            text: ""
                            width: 215
                            height: 30
                            textColor: "#333"
                            bg.color: "#fff"
                            bg.opacity: 1.0
                            maxLength: 30
                            size: 14
                            input.font.bold: true
                            input.passwordCharacter: '*'
                            input.echoMode: TextInput.Password
                            detailColor: main.detailColor
                            visible: true
                        }
                    }

                    Button {
                        id: btnText
                        x: 140
                        y: 290
                        text: 'Connectar'
                        size: 12
                        detailColor: main.detailColor
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (ContextPlugin.getCurrentNetwork() == infoRede.text) {
                                    ContextPlugin.disconnectWireless()
                                } else {
                                    if ((wifiInfo.password != '')) {
                                        ContextPlugin.setWirelessProperty(wifiInfo.index, 'key', wifiInfo.password)
                                    }
                                    ContextPlugin.connectWireless(wifiInfo.index)
                                }

                                waitLoading.visible = true
                                loading.stop()
                                loading.start()
                                wifiList.model = []
                                wifiInfo.visible = false
                            }
                        }
                    }

                    Label {
                        y: 15
                        x: wifiInfo.width - 25
                        text: '\uf00d'
                        color: "#fff"
                        font.pixelSize: 16
                        font.family: "Font Awesome 5 Free"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                wifiList.model = ContextPlugin.redes().split(";")
                                wifiInfo.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: pluginItemsAdd
        x: 0
        y: dinamicContent.y + dinamicContent.height
        width: parent.width
        height: 200
        color: "transparent"

        Item {
            id: acessItemsAdd
            x: 0
            y: 0
            width: parent.width
            height: 10
            Repeater {
                model: [
                    ["Audio", "\uf028"], ["Internet", "\uf1eb"], ["Calendar", "\uf073"], ["Color", "\uf043"], ["Power", "\uf011"], ["Display", "\uf108"]
                ]
                Rectangle {
                    x: ((index < 3) ? 83 * index : 83 * (index - 3))
                    y: ((index < 3) ? 0 : 83)
                    width: 83
                    height: 83
                    color: "transparent"

                    MouseArea {
                        id: pluginMouse
                        anchors.fill: parent

                        onClicked: {
                            if (modelData[0] == "Internet") {
                                pluginWifi.visible = true
                                pluginCalendar.visible = false
                            }

                            if (modelData[0] == "Calendar") {
                                pluginWifi.visible = false
                                pluginCalendar.visible = true
                            }
                        }
                    }

                        Rectangle {
                            width: 26
                            height: 26
                            radius: 26
                            anchors.fill: parent
                            anchors.margins: 14
                            //border {width: 1; color: detailColor}
                            color: "transparent"//detailColor
                        }

                        Rectangle {
                            id: pluginMask
                            width: 24
                            height: 24
                            radius: 24
                            anchors.fill: parent
                            anchors.margins: 16
                            color: "transparent"//"#ffffff"
                        }

                        Text {
                            text: modelData[0]
                            anchors.right: parent.right
                            anchors.rightMargin: 0
                            anchors.left: parent.left
                            anchors.leftMargin: 0
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -5
                            font.pixelSize: 12
                            color: accessDetail
                        }

                        Label {
                            id: acessIcon
                            //x: 23
                            y: 25
                            anchors.centerIn: parent
                            text: modelData[1]
                            color: "#fff"
                            font.pixelSize: 28
                            font.family: "Font Awesome 5 Free"
                        }
                    }
                }
         }
    }

    Rectangle {
        id: controls
        x: 0
        y: (pluginItemsAdd.y + pluginItemsAdd.height) - 20
        width: parent.width
        height: 40
        color: "transparent"

        Label {
            x: 25
            y: (parent.height / 2) - 6
            text: "\uf028"
            color: "#fff"
            font.pixelSize: 14
            font.family: "Font Awesome 5 Free"
        }

        Controller {
            id: volume
            x: 50
            y: (parent.height / 2) - 2
            width: 80
            height: 5
            percentage: 92
            bg.color: "#fff"
            detail: main.detailColor

            onChange: {
                ContextPlugin.volume(perValue)
            }
        }

        Label {
            x: 140
            y: (parent.height / 2) - 6
            text: "\uf185"
            color: "#fff"
            font.pixelSize: 14
            font.family: "Font Awesome 5 Free"
        }

        Controller {
            x: 160
            y: (parent.height / 2) - 2
            width: 80
            height: 5
            percentage: 92
            bg.color: "#fff"
            detail: main.detailColor

            onChange: {
                ContextPlugin.brightness(perValue)
            }
        }
    }
}
