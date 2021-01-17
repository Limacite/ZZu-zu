let map;
function initMap(lat,lng) {
  map = new google.maps.Map(document.getElementById("mapArea"),{
    center: { lat: lat, lng: lng },
    zoom: 15,
    mapTypeId :"roadmap"
  });
}

window.onload = function(){
  navigator.geolocation.getCurrentPosition(function(position) {
      //position から緯度経度（ユーザーの位置）のオブジェクトを作成し変数に代入
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      console.log("lat:" + pos.lat + "lng:" + pos.lng );
      console.log("Map Complete");
      initMap(pos.lat,pos.lng);

    });
}
