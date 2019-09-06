import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "./Components"
import "./utils.js" as Utils


App {
    id: main
    visible: false
    x: 0
    y: Screen.height - 40
    width: Screen.width
    height: 40
    title: qsTr("Synth-Panel")
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowDoesNotAcceptFocus | Qt.WindowStaysOnTopHint | Qt.WA_X11NetWmWindowTypeDock

    property var neonMenu: Object
    // yellow #FFFB00, purple "#7310A2", crimson #dc143c, black "#333333", blue "#007fff", red #FF0D00, orange #ff9900, green #00ff00
    property string detailColor: "#007fff"//"#7310A2"
    property int efeito1: 300
    property int efeito2: 600
    property string blurColor: "#161616"
    property double blurColorOpc: 0.8
    property int blurControl: 100
    property double blurControlOpc: 1
    property double blurSaturation: 1
    property double clickOpc: 0.0
    property double startOpc: 0.0
    property int mainId: 0

    property var fixShowInfos: Object
    property var showAppInfo: Object
    property var unfix: Object
    property var trayShowInfo: Object
    property var acessoRapido: Object

    property int launcherX: 0
    property var launcher: []
    property int trayIconsX: 0

    property var subAppbar: subAppbar
    property var applicationBar: applicationBar

    property int subLauncherX: 0
    property int subLauncherX2: 0
    property int defaultWidth: 48
    property bool subLauncherStarted: true
    property bool windowVerify: false

    property bool accessOpened: true
    property bool menuOpened: true
    property alias arrowAside: arrowAside


    Image {
        id: blur
        x: 0
        y: (~(Screen.height - main.height)) + 1
        width: Screen.width
        height: Screen.height
        source: "image://grab"
        fillMode: Image.PreserveAspectCrop
        visible: false
        cache: false
    }

    FastBlur {
        id: fastBlur
        anchors.fill: blur
        source: blur
        radius: blurControl
    }

    Blend {
        id: blend
        anchors.fill: fastBlur
        source: fastBlur
        foregroundSource: fastBlur
        mode: "softLight"
        opacity: blurControlOpc
    }

    HueSaturation {
        id: saturation
        anchors.fill: blur
        source: fastBlur
        hue: 0
        saturation: blurSaturation
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
        opacity: blurColorOpc//0.3
        color: blurColor//"#161616"
    }

//    Rectangle {
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 0
//        anchors.left: parent.left
//        anchors.leftMargin: 0
//        anchors.right: parent.right
//        anchors.rightMargin: 0
//        height: 2
//        color: "#161616"
//    }


    function blurRefresh(arg) {
        blur.source = ""
        blur.source = arg
    }

    function removeAllWindows() {

        for (var i = 0; i < subAppbar.children.length; i++) {
            if (typeof subAppbar.children[i] != "undefined") {
                delete subAppbar.children[i]
            }
        }

        for (var k = 0; k < applicationBar.children.length; k++) {
            if (typeof(applicationBar.children[k]) !== "undefined") {
                applicationBar.children[k]._instance = false
                applicationBar.children[k].effect.glowRadius = 0
                applicationBar.children[k].effect.opacity = 0
                applicationBar.children[k].bgOpc.opacity = 0
            }
        }

        subLauncherX = 0
        subAppbar.children = []
        activeWindow()
    }

    function addWindow(args) {
        var nitems = args.split('=#=')
        if (nitems[1] !== 'Neon_Panel') {
            desktopWindow(nitems[0], nitems[1], nitems[2], nitems[3], nitems[4])
        }

        activeWindow()
    }

    signal getAddWindow(string arg)
    onGetAddWindow: addWindow(arg)


    function createWindow(args) {

        windowVerify = true
        clearWindow()

        var wins = args.split('|@|')

        for (var i = 1; i < wins.length; i++) {
           var nitems = wins[i].split('=#=')
           if (nitems[1] !== 'Neon_Panel') {
               desktopWindow(nitems[0], nitems[1], nitems[2], nitems[3], nitems[4])
           }
        }

        for (var k = 0; k < applicationBar.children.length; k++) {
            if (typeof(applicationBar.children[k]) !== "undefined") {

                applicationBar.children[k]._instance = false
                var setInstace = false

                for (var j = 1; j < wins.length; j++) {

                    var _nitems = wins[j].split('=#=')

                    if (applicationBar.children[k].pidname === _nitems[1]) {
                        setInstace = true
                        break
                    }
                }

                if (setInstace) {
                    applicationBar.children[k]._instance = true
                }
            }
        }

        activeWindow()
    }

    signal getCreateWindow(string arg)
    onGetCreateWindow: createWindow(arg)

    function activeWindow() {

        for (var t = 0; t < subAppbar.children.length; t++) {
            if (typeof(subAppbar.children[t]) !== "undefined") {
                if (subAppbar.children[t].pidname === Context.windowFocused() || Context.windowFocusedId(subAppbar.children[t].pidname) === 1) {
                    //subAppbar.children[t].destak.height = 2
                    subAppbar.children[t].effect.glowRadius = 3
                    subAppbar.children[t].effect.opacity = 1
                    subAppbar.children[t].bgOpc.opacity = 0.3
                    subAppbar.children[t].destacad = true
                } else {
                    //subAppbar.children[t].destak.height = 2
                    subAppbar.children[t].effect.glowRadius = 0
                    subAppbar.children[t].effect.opacity = 0
                    subAppbar.children[t].bgOpc.opacity = 0
                    subAppbar.children[t].destacad = false
                }
            }
        }

        for (var k = 0; k < applicationBar.children.length; k++) {
            if (typeof(applicationBar.children[k]) !== "undefined") {
                if (applicationBar.children[k].pidname === Context.windowFocused() || Context.windowFocusedId(applicationBar.children[k].pidname) === 1) {
                    applicationBar.children[k].effect.glowRadius = 3
                    applicationBar.children[k].effect.opacity = 1
                    applicationBar.children[k].bgOpc.opacity = 0.3
                    applicationBar.children[k].destacad = true
                } else {
                    try {
                        applicationBar.children[k].effect.glowRadius = 0
                        applicationBar.children[k].effect.opacity = 0
                        applicationBar.children[k].bgOpc.opacity = 0
                        applicationBar.children[k].destacad = false
                    } catch (err) {}
                }
            }
        }
    }


    function clearWindow() {

        if (windowVerify) {

            for (var i = 0; i < subAppbar.children.length; i++) {
                subAppbar.children[i].destroy()
                delete subAppbar.children[i]
            }

            //subLauncher = []
            subAppbar.children = []
            subLauncherStarted = true
            //separatorBar.visible = false
            windowVerify = false

            if (launcher.length > 0) {
                subLauncherX = 10
                subLauncherX2 = 0
            } else {
                subLauncherX = 0
                subLauncherX2 = 0
            }
        }

        activeWindow()
    }

    function desktopWindow(_nome, wmclass, winId, pid, obclass) {

        //clearWindow()

        var fixicede = false
        //subAppbar.width = defaultWidth

//        for (var j = 0; j < subAppbar.children.length; j++) {
//            if (subAppbar.children[j].pidname === wmclass) {
//                fixicede = true
//            }
//        }

        for (var k = 0; k < applicationBar.children.length; k++) {
            if (typeof(applicationBar.children[k]) !== "undefined") {
                if (applicationBar.children[k].pidname === wmclass) {
                    applicationBar.children[k]._instance = true
                    fixicede = true
                }
            }
        }

        if (!fixicede) {
            for (var t = 0; t < subAppbar.children.length; t++) {
                if (typeof(subAppbar.children[t]) !== "undefined") {
                    if (subAppbar.children[t].pidname === wmclass) {
                        fixicede = true
                    }
                    //subAppbar.width += defaultWidth
                }
            }
        }

        if (_nome !== "" && !fixicede) {

            if (subLauncherStarted) {

                if (subAppbar.children.length > 0) {
                    subLauncherX = 10
                    subLauncherX2 = 0
                } else {
                    subLauncherX = 0
                    subLauncherX2 = 0
                }

                subLauncherStarted = false
            }

            var compon = Qt.createComponent("launchers/Applications.qml")
            //var obj;

            if (subAppbar.x + subLauncherX + defaultWidth < plugins.x) {
                btnShowMore.visible = false
                compon.createObject(subAppbar, {'x': subLauncherX, 'y': 0, 'nome': _nome, 'pidname': wmclass, 'winId': winId, 'pid': pid, 'obclass': obclass})
                subLauncherX += defaultWidth

                if (!btnShowMore.moreArea) {
                    btnShowMore.moreArea = true
                    verticaline.height -= 40
                    btnShowMore.rotation = 0
                    main.y += 40
                    main.height -= 40
                    accessSpeed.y = 0
                    Context.showMoreWindows(mainId, 40)
                }

            } else {
                btnShowMore.visible = true
                compon.createObject(subAppbar2, {'x': subLauncherX2, 'y': 0, 'nome': _nome, 'pidname': wmclass, 'winId': winId, 'pid': pid, 'obclass': obclass})
                subLauncherX2 += defaultWidth
            }

            //subLauncher.push(obj)
            //obj.destak.visible = true
            //if (subAppbar.children.length > 0) separatorBar.visible = true

            activeWindow()
        }
    }

    function addTryIcon(args) {

        plugins.x -= 28
        plugins.width += 28

        var lista = args.split("|@|")

        var compon = Qt.createComponent("launchers/TrayIcon.qml")
        compon.createObject(systray, {'x': trayIconsX, 'y': 0, 'name': lista[0], 'winId': lista[1], 'wclass': lista[2], 'pid': lista[3]})

        trayIconsX += 28
    }

    signal tryIcon(string arg)
    onTryIcon: addTryIcon(arg)

    function removeTryIcon(args) {

        var icons = []

        for (var i = 0; i < systray.children.length; i++) {
            if (systray.children[i].winId === args) {
                plugins.x += 28
                plugins.width -= 28
                trayIconsX -= 28
                systray.children[i].destroy()
                delete systray.children[i]
            } else {
                icons.push(systray.children[i])
            }
        }

        systray.children = icons

        plugins.x = utitlitaries.width - 110
        plugins.width = 110
        trayIconsX = 0

        for (var j = 0; j < systray.children.length; j++) {
            plugins.x -= 28
            plugins.width += 28
            systray.children[j].x = trayIconsX
            trayIconsX += 28
        }
    }

    signal getRemoveTryIcon(int arg)
    onGetRemoveTryIcon: removeTryIcon(arg)


    function notifications(arg) {

        var exist = false

        for (var k = 0; k < subAppbar.children.length; k++) {
            if (subAppbar.children[k].winId === arg) {
                exist = true
                break
            }
        }

        if (!exist) {
            for (var i = 0; i < systray.children.length; i++) {
                if (systray.children[i].winId === arg) {
                    systray.children[i].hasNotification.visible = true
                    break
                }
            }
        }
    }

    signal getNotifications(int arg)
    onGetNotifications: notifications(arg)

    function fixLaunchers(files) {

        if (applicationBar.x + applicationBar.width + 200 <  plugins.x) {

            for (var i = 0; i < files.length; i++) {

                var list = Context.addLauncher(files[i])
                var fixed = false

                for (var k = 0; k < applicationBar.children.length; k++) {
                    if (typeof(applicationBar.children[k]) !== "undefined") {
                        if (applicationBar.children[k].pidname === list[3]) {
                            fixed = true
                            break
                        }
                    }
                }

                if (list[0] !== "" && !fixed) {

                    var component = Qt.createComponent("launchers/Application.qml")
                    var obj = component.createObject(applicationBar, {'x': launcherX, 'y': 0, 'url': list[1], 'nome': list[0], 'exec': list[2], 'pidname': list[3]})

                    launcherX += defaultWidth
                    launcher.push(obj)
                    applicationBar.width += defaultWidth
                    subAppbar.x = applicationBar.x + applicationBar.width
                    Context.fixedLauncher(list[3], files[i], 0)
                }

            }
        }
    }

    DropArea {
        id: drop
        anchors.fill: parent
        enabled: true

        onEntered: {
            //console.log("entered")
        }

        onExited: {
            //console.log("exited")
        }

        onDropped: {
            var files = drop.urls.toString().split(',')
            fixLaunchers(files)
            drop.acceptProposedAction()
        }

    }

    MouseArea {
        id: mouseMain
        anchors.fill: parent

        onPressed: {
            clickOpc = startOpc
            //neonMenu.visible = false
            neonMenu.textSearch.focus = false
            neonMenu.desactive()
            menuOpened = false
            //neonMenu.addApps()
            showAppInfo.visible = false
            trayShowInfo.visible = false

            unfix.visible = false

            btnCycle.border.color = "#fff"

            //acessoRapido.visible = false
            //acessoRapido.accessBlur.source = ""
            accessOpened = true
            acessoRapido.desactive()

            //arrowAside.text = '\uf106'
            accessOpened = true
            //activeWindow()
        }
    }

    Rectangle {
        id: utitlitaries
        anchors.fill: parent
        color: "transparent"
/*
        Rectangle {
            id: bottomBar
            x: 0
            y: parent.height - 1.5
            height: 1.5
            width: parent.width
            color: "#000000"
            opacity: 0.7
        }
*/
        Rectangle {
            id: btnMenuSub
            x: 8
            y: 8
            width: 24
            height: 24
            color: main.detailColor
            opacity: 0//clickOpc
            radius: 12
        }

        Rectangle {
            id: btnMenu
            x: 0
            y: 0
            width: 48
            height: 40
            color: "transparent"

            MouseArea {
                id: mouseArea
                anchors.bottomMargin: 0
                anchors.leftMargin: 1
                anchors.topMargin: 0
                anchors.rightMargin: -1
                anchors.fill: parent

                onPressed: {

                    //neonMenu.updateApps()
                    //acessoRapido.accessBlur.source = ""
                    //acessoRapido.visible = false
                    acessoRapido.desactive()

                    arrowAside.text = '\uf106'
                    accessOpened = true

                    trayShowInfo.visible = false
                    fixShowInfos.visible = false
                    showAppInfo.visible = false

                    //neonMenu.x = 0
                    //neonMenu.y = main.y - neonMenu.height //(neonMenu.height + 4)
                    neonMenu.textSearch.text = ""
                    neonMenu.textSearch.focus = true
                    //neonMenu.addApps()
                    //neonMenu.desfocusApps()

                    if (menuOpened) {
                        menuOpened = false
                        btnCycle.border.color = main.detailColor
                        neonMenu.blur.source = ""
                        neonMenu.blur.source = "image://grab/crop"
                        neonMenu.visible = true


                        if (Context.modified() === 1) {
                            neonMenu.updateApps()
                        }

                        neonMenu.requestActivate()

                        //clickOpc = 0.3
                    } else {

                        neonMenu.desactive()
                        menuOpened = true

                        //neonMenu.blur.source = ""
                        btnCycle.border.color = "#fff"
                        //clickOpc = startOpc
                        //neonMenu.visible = false

                        //neonMenu.addApps()
                    }

                    //activeWindow()
                }

                Rectangle {
                    id: btnCycle
                    x: 12
                    y: 8
                    width: 24
                    height: 24
                    color: "transparent"
                    border {width: 2; color: "#fff"}
                    radius: 12
                    onColorChanged: {
                        console.log('ok')
                    }
                }
            }
        }

        Item {
            id: applicationBar
            x: 48
            y: 0
            z: 9
            width: 0
            height: 40
        }

        Item {
           id: subAppbar
           x: applicationBar.x + applicationBar.width
           width: 3
           height: 40

//           Rectangle {
//              id: separatorBar
//              x: 0
//              y: 5
//              width: 1
//              height: 30
//              color: "#ffffff"
//              opacity: 0.3
//              visible: false
//           }
        }

        Item {
           id: subAppbar2
           y: 40
           x: 0
           width: plugins.x
           height: 40

           Rectangle {
               y: 1
               x: 0
               width: plugins.x
               height: 1
               color: "#ffffff"
               opacity: 0.1
           }

           Rectangle {
              id: separatorBar2
              x: 0
              y: 5
              width: 1
              height: 30
              color: "#ffffff"
              opacity: 0.3
              visible: false
           }
        }

        Rectangle {
            id: plugins
            x: parent.width - 110
            y: 0
            height: main.height
            width: 110
            color: "transparent"

            Rectangle {
                id: verticaline
                x: 0
                y: 0
                height: main.height
                width: 20
                color: "transparent"

                Image {
                    id: btnShowMore
                    y: (parent.height / 2) - (height / 2)
                    height: 20
                    width: 20
                    source: 'qrc:/Resources/icon-down.png'
                    rotation: 0
                    visible: false

                    property bool moreArea: true

                    MouseArea {
                        anchors.fill: parent

                        onPressed: {

                            //acessoRapido.visible = false
                            //acessoRapido.accessBlur.source = ""

                            menuOpened = true
                            btnCycle.border.color = "#fff"
                            neonMenu.desactive()

                            acessoRapido.desactive()
                            accessOpened = true
                            arrowAside.text = '\uf106'
                            trayShowInfo.visible = false
                            showAppInfo.visible = false

                            if (parent.moreArea) {

                                main.y -= 40
                                btnShowMore.moreArea = false
                                verticaline.height += 40
                                btnShowMore.rotation = 180
                                main.height += 40
                                accessSpeed.y = 19
                                Context.showMoreWindows(mainId, 80)

                            } else {

                                btnShowMore.moreArea = true
                                verticaline.height -= 40
                                btnShowMore.rotation = 0
                                main.y += 40
                                main.height -= 40
                                accessSpeed.y = 0
                                Context.showMoreWindows(mainId, 40)
                            }

                            y = (parent.height / 2) - (height / 2)
                            activeWindow()
                        }
                    }
                }
            }

            Rectangle {
                id: systray
                x: (ContextPlugin.hasBattery() ? verticaline.width - 16 : verticaline.width)
                width: (parent.width - verticaline.width) - 95
                height: main.height
                color: "transparent"
            }

            Rectangle {
                id: battery
                x: clock.x - 24
                width: (ContextPlugin.hasBattery() === 1 ? 20 : 0)
                height: main.height
                color: "transparent"
                clip: true

                Label {
                    x: 2
                    y: 28
                    text: '\uf244'
                    size: 12
                    color: main.detailColor
                    transform: Rotation {angle: -90}
                }

                Rectangle {
                    x: 6
                    y: 14
                    width: 7
                    height: (ContextPlugin.hasBattery() === 1 ? 14 : 0)
                    color: main.detailColor 
                }

                Label {
                    x: 7
                    y: 14
                    text: '\uf0e7'
                    color: '#fff'
                    size: 12
                    visible: (ContextPlugin.isPlugged() === 1 ? true : false)
                }
            }

            Text {
                id: clock
                x: 102
                text: Utils.getTime().split('|')[0]//Utils.getTime()
                font.bold: false
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 11
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.right: parent.right
                anchors.rightMargin: 35
                font.pointSize: 12
                color: "#ffffff"
                font.family: "roboto light"

                Timer {
                    id: clockStart
                    interval: 500
                    running: true
                    repeat: true
                    onTriggered: {
                        var d = Utils.getTime().split('|')
                        clock.text = d[0]
                        acessoRapido.acessText.text = d[1]
                    }
               }
            }

            Rectangle {
                id: accessSpeed
                x: 0
                y: 0
                width: 16
                height: 40
                color: "transparent"
                anchors.right: parent.right
                anchors.rightMargin: 10

                Rectangle {
                    x: 0
                    y: 9
                    width: 16
                    height: 40
                    color: "transparent"
                    Label {
                        id: arrowAside
                        text: '\uf106'
                        font.family: "Font Awesome 5 Free"
                        color: "#fff"
                        //opacity: 0.5
                        size: 22
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    //hoverEnabled: true

                    onPressed: {

                        //acessoRapido.back()

                        trayShowInfo.visible = false
                        showAppInfo.visible = false
                        //neonMenu.visible = false
                        neonMenu.desactive()
                        menuOpened = false

                        menuOpened = true
                        btnCycle.border.color = "#fff"
                        neonMenu.desactive()

                        if (accessOpened) {

                            acessoRapido.accessBlur.source = ""
                            accessOpened = false
                            acessoRapido.visible = true
                            acessoRapido.accessBlur.source = "image://grab/crop"
                            acessoRapido.requestActivate()
                            //acessoRapido.aniAcess.to = main.width - 249
                            //acessoRapido.aniAcess.stop()
                            //acessoRapido.aniAcess.start()
                            arrowAside.text = '\uf107'

                        } else {

                            accessOpened = true
                            //acessoRapido.visible = false
                            //acessoRapido.accessBlur.source = ""

                            acessoRapido.desactive()

                            arrowAside.text = '\uf106'
                        }


                        activeWindow()
                    }   
                }
            }
        }
    }

    Timer {
        id: fixedLaunchers
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            fixLaunchers(Context.getAllFixedLaunchers())
            createWindow(Context.getAllWindows())
        }
    }

    Component.onCompleted: {

        height = Screen.height - 40
        width = Screen.width

        var component_ = Qt.createComponent("qrc:/plugins/NeonMenu.qml")
        neonMenu = component_.createObject(main)
        neonMenu.visible = false

        var info = Qt.createComponent("qrc:/launchers/appFixShowInfo.qml")
        fixShowInfos = info.createObject(applicationBar)
        fixShowInfos.visible = false

        var info2 = Qt.createComponent("qrc:/launchers/appShowInfo.qml")
        showAppInfo = info2.createObject(applicationBar)
        showAppInfo.visible = false

        var _unfix = Qt.createComponent("qrc:/launchers/appUnfix.qml")
        unfix = _unfix.createObject(applicationBar)
        unfix.visible = false

        var trayInfo = Qt.createComponent("qrc:/launchers/TrayShowInfo.qml")
        trayShowInfo = trayInfo.createObject(main)
        trayShowInfo.visible = false

        var access = Qt.createComponent("qrc:/plugins/Access.qml")
        acessoRapido = access.createObject(main)

        //Context.changeThemeColor(main.detailColor)
        main.visible = true

        fixedLaunchers.start()
        //Context.gtkThemeChangeDetail(main.detailColor)
        //clockStart.start()
        //Context.libraryVoidLoad("write")
        //Context.libraryVoidLoad(17, "shenoisz", "showMsg")
    }
}
