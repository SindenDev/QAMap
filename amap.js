var amap_key = "341c6d9e9840212d799314a326a44857"
var car_id = "abcd123456"
var width = 200
var height = 200
var zoom =  10
var latitude = 22.5574462
var longitude = 113.9449748

function sendXMLHttpRequest(url, callback){
    var req = new XMLHttpRequest;
    req.open("GET",url);
    req.onreadystatechange = function() {
        var status = req.readyState;
        if (status === XMLHttpRequest.DONE) {
//                var objectArray = JSON.parse(req.responseText);
//            console.debug(req.responseText)
            callback(JSON.parse(req.responseText));
        }
    }
    req.send();
}

//http://restapi.amap.com/v3/staticmap?location=116.481485,39.990464&zoom=10&size=750*300&traffic=1&key=341c6d9e9840212d799314a326a44857
//http://restapi.amap.com/v3/staticmap?location=22.5750427,113.92297&zoom=7&size=180*120&traffic=1&key=341c6d9e9840212d799314a326a44857
//静态地图
function getAMapSource() {
    var url = "http://restapi.amap.com/v3/staticmap?location="
    url += longitude +","+ latitude
    url += "&zoom="+ zoom
    url += "&size="+width+"*"+height
    url += "&traffic=1"
    url += "&key=" + amap_key
    return url
}
//            AMAP_API.getGeoCode("流塘路口","深圳", function(geo){
//                for(var i in  geo.geocodes){
//                    console.debug()
//                    var location = geo.geocodes[i].location.split(",")
//                    testItem.center.latitude = location[1]
//                    testItem.center.longitude = location[0]
//                    map.center = testItem.center
//                }
//            })
function getGeoCode(address, city, callback){
    var url = "http://restapi.amap.com/v3/geocode/geo?key=" + amap_key
        url += "&address="+ address+"&city="+city
    sendXMLHttpRequest(url,callback)
}
//抓路服务
//            AMAP_API.locations_info.push({location:"116.496167,39.917066",time:"1434077500",direction:"1",speed:"1"})
//            AMAP_API.locations_info.push({location:"116.496149,39.917205",time:"1434077501",direction:"1",speed:"1"})
//            AMAP_API.locations_info.push({location:"116.496149,39.917326",time:"1434077510",direction:"2",speed:"2"})
//            AMAP_API.getAutoGrasp(function(grasp){
//                console.debug("grasp",grasp.info)
//                for(var i in grasp.roads){
//                    console.debug("G:",grasp.roads[i].roadname, grasp.roads[i].crosspoint)
//                }
//            })
var locations_info = new Array
//AMAP_API.locations_info.push({location:"116.496167,39.917066",time:"1434077500",direction:"1",speed:"1"})
function getAutoGrasp(callback){

    var locations="", time="", direction="", speed=""

    for(var i in locations_info)
    {
        locations += locations_info[i].location + "|"
        time += locations_info[i].time + ","
        direction += locations_info[i].direction + ","
        speed += locations_info[i].speed + ","
    }
    locations = locations.substring(0, locations.lastIndexOf('|'));
    time = time.substring(0, time.lastIndexOf(','));
    direction = direction.substring(0, direction.lastIndexOf(','));
    speed = speed.substring(0, speed.lastIndexOf(','));

    var url = "http://restapi.amap.com/v3/autograsp?key=" + amap_key
        url += "&carid=" + car_id
        url += "&locations=" + locations
        url += "&time=" + time
        url += "&direction=" + direction
        url += "&speed=" + speed
    
    sendXMLHttpRequest(url,callback)
    locations.length = 0
}

//路径规划--驾车路径规划
//            var origin="116.481028,39.989643",destination="116.434446,39.90816"
//            AMAP_API.getDrivingDirection(origin, destination, function(driving){
//                console.debug("driving.info",driving.info)
//            })
function getDrivingDirection(origin, destination,callback){
    var url = "http://restapi.amap.com/v3/direction/driving?key=" + amap_key
    url += "&origin=" + origin
    url += "+&destination=" +destination
    
    sendXMLHttpRequest(url,callback)
}

//输入提示
function getInputtips(keywords, callback){
    var url = "http://restapi.amap.com/v3/assistant/inputtips?key=" + amap_key
    url += "&keywords="+ keywords
    url += "&location=" +longitude +","+ latitude
    url += "&datatype=all"   
    sendXMLHttpRequest(url,callback)
}



