let map;
function initMap() {
  map = new google.maps.Map(document.getElementById("mapArea"),{
    center: { lat: -34.397, lng: 150.644 },
    zoom: 8,
    mapTypeId :"roadmap"
  });
}

window.onload = function(){
    console.log("asafaf");
    initMap();
}
