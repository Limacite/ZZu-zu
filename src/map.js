let map;
let marker = null;
let pos  = {lat:0,lng:0};

function initMap(latlng) {
  map = new google.maps.Map(document.getElementById("mapArea"),{
    center: latlng ,
    zoom: 15,
    mapTypeId :"roadmap"
  });

  map.addListener('click', function(e){
      if (marker == null) {
          marker = new google.maps.Marker({
            position: e.latLng,
            map: map,
            title: "🐡",
            animation: google.maps.Animation.DROP
          });
      }else {
          marker.setMap(null);
          marker = null;
          marker = new google.maps.Marker({
            position: e.latLng,
            map: map,
            title: "🐡",
            animation: google.maps.Animation.DROP
          });
      }


  });

}

window.onload = function(){
  navigator.geolocation.getCurrentPosition(function(position) {
      //position から緯度経度（ユーザーの位置）のオブジェクトを作成し変数に代入
      pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      console.log("lat:" + pos.lat + "lng:" + pos.lng );
      console.log("Map Complete");
      initMap(pos);

    });
}

window.appEventListner("ps",function(){
  app.ports.receivePosition.send(pos);
});
