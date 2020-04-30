//contents of Switch.qml
import QtQuick 2.9
import QtGraphicalEffects 1.0


Rectangle {
    id: swit
    width: 30
    height: 14
    radius: height
    antialiasing: true

    property bool actived: false
    property bool value: false
    property bool noStatus: false
    property string colorDetail: "#7310A2"

    signal change

    function updateStates() {

        if (mouseControl.effectEnd) {
            if (!mouseControl.active) {
                animation.to = (controlBtn.width - (controlBtn.width / 2)) + 10
                animation.start()
                swit.value = true
            } else {
                animation.to = -(swit.width / 2)
                animation.start()
                swit.value = false
            }

            mouseControl.active = !mouseControl.active
            swit.change()
            effect.start()
            mouseControl.effectEnd = false

            noStatus = true
            actived = swit.value
            noStatus = false
        }
    }

    onActivedChanged: {
        if (!noStatus) updateStates()
    }

    PropertyAnimation { id: animation; target: controlBtn; property: "x"; to: 0; duration: main.efeito1 }

    MouseArea {
        id: mouseControl
        anchors.fill: parent
        property bool active: false
        property bool effectEnd: true

        Rectangle {
            id: controlBtn
            x: 0
            y: -(swit.height / 2) - 2
            width: swit.height * 2 + 4
            height: swit.height * 2 + 4
            radius: swit.height + 2
            color: colorDetail
            z: 1
        }

        Rectangle {
            id: switBar
            x: 0
            y: 0
            width: controlBtn.x + (controlBtn.width / 2)
            height: swit.height
            color: colorDetail
            radius: swit.height + 2
        }

        RectangularGlow {
            id: effect1
            anchors.fill: controlBtn
            glowRadius: 1
            spread: 0
            color: main.detailColor
            cornerRadius: controlBtn.radius + glowRadius
            opacity: 0.8
        }

        RectangularGlow {
            id: effect2
            anchors.fill: switBar
            glowRadius: 2
            spread: 0
            color: main.detailColor
            cornerRadius: switBar.radius + glowRadius
            opacity: 0.8
        }

        onClicked: {
            updateStates()
        }
    }

    Timer {
        id: effect
        interval: main.efeito1
        repeat: false
        onTriggered: {
            mouseControl.effectEnd = true
        }
    }

    Component.onCompleted: {

        if (value) {
            controlBtn.x = (controlBtn.width - (controlBtn.width / 2)) + 10
            mouseControl.active = true
        } else {
            controlBtn.x = -(width / 2)
            mouseControl.active = false
        }
    }
}
