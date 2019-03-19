import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0


Rectangle {
    x: 0
    y: 0
    width: 83
    height: 83
    color: "transparent"

    property string btnName: ''
    property string qmlName: ''
    property string libName: ''
    property string iconName: ''

    MouseArea {
        id: pluginMouse
        anchors.fill: parent

        onClicked: {
            acessItemsAdd.visible = false
            primaryPlugins.visible = false
            qmlShowPlugin.visible = true
            pluginName.text = btnName
            Qt.createComponent(qmlName).createObject(importPluginShow)
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
        text: btnName
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

    Loader {
        source: "file://" + Context.basepath + "/plugins/" + iconName
    }
}

