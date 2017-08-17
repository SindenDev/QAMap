import QtQuick 2.0
import 'awesome.js' as Awesome

Text {
    property string name:"version"
    text: Awesome.map[name]
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family:"FontAwesome"// fontAwesome.name
    font.pixelSize: 24
//    Component.onCompleted: console.debug(Awesome.map['align_justify'])
    FontLoader { id: fontAwesome; source: "qrc:/fontawesome/FontAwesome.otf" }
}
