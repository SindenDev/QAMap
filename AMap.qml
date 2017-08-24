import QtQuick 2.4
import QtLocation 5.9
import QtPositioning 5.6
import QtQuick.Controls 2.2
import "amap.js" as AMAP_API
import "transform.js" as Transform
import "fontawesome"// as FontAwesome
Map { 
    id: map
    width: 100; height: 100
    zoomLevel: 18
    center: QtPositioning.coordinate(22.5574462,113.9449748)
//    Behavior on center {
//        CoordinateAnimation {
//            duration: 1000
//            easing.type: Easing.Linear}
//    }
    
//    if(googleMap.plugin.name == Transform.transformMapName)
//    {//GoogleMap.GPS.gcj_encrypt(data_json.Lat, data_json.Lon)//
//        var gmap =  Transform.wgs2gcj(lat,lon)
//        lat = gmap.lat
//        lon = gmap.lon
//    }

    //    Address{}
    
    function testWeather(){
        AMAP_API.getWeatherInfo("深圳", function(info){
            console.debug(info.lives[0].province
                          +info.lives[0].city + "\n"
                          +"天气:"+info.lives[0].weather + "\n"
                          +"温度:"+info.lives[0].temperature+"度\n"
                          +info.lives[0].winddirection + info.lives[0].windpower + "级\n"
                          +"湿度:" + info.lives[0].humidity)
        })
    }
    
    function testAutoGrasp(){
console.debug(Date())
        var infos = new Array
        console.debug()
        infos.push({location:"113.944037,22.556817",time: Math.floor(Date.now()/1000),direction:"1",speed:"1"})
        infos.push({location:"113.943425,22.556732",time: Math.floor(1+Date.now()/1000),direction:"1",speed:"1"})
        infos.push({location:"113.942438,22.556985",time: Math.floor(3+Date.now()/1000),direction:"2",speed:"2"})
        AMAP_API.getAutoGrasp(infos,function(grasp){
            console.debug("grasp",grasp.info, JSON.stringify(grasp))
            for(var i in grasp.roads){
                console.debug("G:",grasp.roads[i].roadname, grasp.roads[i].crosspoint)
               
            }
        })
    }

    function testDrivingDirection(){
        var origin="",destination=""
        AMAP_API.getGeoCode("宝安公园西二门","深圳", function(geo){
            for(var i in  geo.geocodes){
                origin = geo.geocodes[i].location
//                    console.debug()
//                    var location = geo.geocodes[i].location.split(",")
//                    testItem.center.latitude = location[1]
//                    testItem.center.longitude = location[0]
//                    map.center = testItem.center
                AMAP_API.getGeoCode("华瀚科技","深圳", function(geo){
                    for(var i in  geo.geocodes){
                        destination =  geo.geocodes[i].location
    ////                    console.debug()
//                            var location = geo.geocodes[i].location.split(",")
//                            testItem.center.latitude = location[1]
//                            testItem.center.longitude = location[0]
//                            map.center = testItem.center
                        AMAP_API.getDrivingDirection(origin, destination, function(driving){
//                                console.debug("driving.info",origin, destination)

                            var steps = driving.route.paths[0].steps
                            routeLine.addCoordinate(origin.split(",")[1],origin.split(",")[0])
                            for (var i in steps){
//                                    console.debug(steps[i].instruction)
                                 var polylinepoints = steps[i].polyline.split(";")
                                 for(var j in polylinepoints){

                                     var point = polylinepoints[j].split(",")
//                                         console.debug(point[1], ",",point[0])
                                     routeLine.addCoordinate(QtPositioning.coordinate(point[1],point[0]))
                                 }//
                            }
                            routeLine.addCoordinate(destination.split(",")[1],destination.split(",")[0])
                            originItem.center = routeLine.path[0]
                            destinationItem.center = routeLine.path[routeLine.path.length-1]
                        })
                    }
                })
            }
        })    
    }
    activeMapType: map.supportedMapTypes[10]
        plugin: Plugin{
            name: "esri"//"amap"//"googlemaps"
            Component.onCompleted: {
                console.debug(availableServiceProviders,preferred)
                testWeather()
                testDrivingDirection()
                testAutoGrasp()
                console.debug("supportedMapTypes:--------------------------------")
                for(var i in map.supportedMapTypes)
                {
                    console.debug("|-->",i,map.supportedMapTypes[i].description,"->"
                                  ,map.supportedMapTypes[i].mobile,"->"
                                  ,map.supportedMapTypes[i].name)
                }
                console.debug("--------------------------------------------------")
            }
        }

    //    onWidthChanged: AMAP_API.width = width
    //    onHeightChanged: AMAP_API.height =height
    //    onZoomLevelChanged: AMAP_API.zoom = Math.floor(zoomLevel)
        onCenterChanged: {
            AMAP_API.latitude = center.latitude
            AMAP_API.longitude = center.longitude
//            amapImage.source = AMAP_API.getAMapSource()
        }

    //    Image {
    //        id: amapImage
    //        anchors.fill: parent
    //    }

        MapPolyline{
            id: routeLine
            line.width: 6
            line.color: "#46a2da"
        }
        MapCircle {
            id: originItem
            color: "blue"
            radius: 24-map.zoomLevel
        }
        MapCircle {
            id: destinationItem
            color: "blue"
            radius: 24-map.zoomLevel
      }
    
    function addSearchItem(tips){
        searchComboBox.updataModel(tips)  
//        console.debug("Tips", JSON.stringify(tips))
        for(var i in tips){
//            console.debug(tips[i].name,JSON.stringify(tips[i]))
            if("" == tips[i].location) continue
            var point = (tips[i].location).split(",")
            var component = Qt.createComponent("qrc:/MapSearchItem.qml");
    
           if (component.status == Component.Ready){
    
               var search_item  = component.createObject(map, {"name":tips[i].name,"index": (parseInt(i)+1),
                                             "coordinate": QtPositioning.coordinate(point[1], point[0])});
               map.addMapItem(search_item)
                
           }
            
           
//            mapCircleObject.center = QtPositioning.coordinate(point[1],point[0])
//            map.addMapItem(mapCircleObject)
//            map.center = mapCircleObject.center
        }

    } 
    
    ComboBox{
        id: searchComboBox
        anchors.fill: searchTextField
        textRole: "name"
        onCurrentTextChanged: searchTextField.text = currentText
        function updataModel(data){
            model = data
            popup.open()           
            map.clearMapItems()
        }
    }
    TextField{
        id: searchTextField
        placeholderText: qsTr("搜索位置、公交、地铁站")
        text: "松坪山"
        onAccepted: {
            AMAP_API.getInputtips(searchTextField.text, function(tips){
                addSearchItem(tips.tips)                                    
         })
        }
        FontAwesome{
            name: "search"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8
            color: searchIconArea.containsMouse ? "#46a2da" : "grey"
            MouseArea{
                id: searchIconArea
                hoverEnabled: true
                anchors.fill: parent
                onClicked:{                     
                     AMAP_API.getInputtips(searchTextField.text, function(tips){
//                        console.debug("Tips",tips.info, JSON.stringify(tips))
                         addSearchItem(tips.tips)                        
                     })
                }
            }
        }
    }
    
}
