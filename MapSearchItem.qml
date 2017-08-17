import QtQuick 2.4
import QtLocation 5.9
import QtPositioning 5.6; 
import "fontawesome"
MapQuickItem  {    
    property string name: ""
    property int index: 0
    anchorPoint: Qt.point(32,32)
    sourceItem: Item {        
        width: 64; height: 64
        Text {  
            visible: itemArea.containsMouse
            text: qsTr(name)  
            color: "#46a2da"
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
        }
        FontAwesome{
            name: "map_marker"
            color: "red"
            font.pixelSize: 54
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            Text {
                anchors.fill: parent
                text: qsTr(index.toString())
                color: "#46a2da"
                font.pixelSize: 24
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        MouseArea{
            id: itemArea
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
