window.initMap = function() {
  const mapElement = document.getElementById('map');
  if (!mapElement) return;

  const lat = parseFloat(mapElement.dataset.lat);
  const lng = parseFloat(mapElement.dataset.lng);

  const map = new google.maps.Map(mapElement, {
    center: { lat, lng },
    zoom: 16,
  });

  new google.maps.Marker({
    position: { lat, lng },
    map: map,
  });
}

document.addEventListener('turbo:load', () => {
  if (typeof google !== 'undefined' && google.maps) {
    initMap();
  }
});

