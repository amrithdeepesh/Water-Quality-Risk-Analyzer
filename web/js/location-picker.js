"use strict";
document.addEventListener("DOMContentLoaded", function () {
    var host = document.getElementById("sample-location-map");
    var pin = document.getElementById("pincode");
    var find = document.getElementById("locate-pincode");
    var officeSelect = document.getElementById("pin-office");
    var status = document.getElementById("pin-status");
    var lat = document.getElementById("latitude");
    var lng = document.getElementById("longitude");
    var map, selectedMarker, officesLayer, datasetPromise;

    if (!host || typeof L === "undefined") {
        if (status) status.textContent = "The location map could not load. You can still enter coordinates manually.";
        return;
    }
    map = L.map(host, { scrollWheelZoom: true, dragging: true, touchZoom: true, doubleClickZoom: true })
        .setView([22.7, 79.0], 4.5);
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
        maxZoom: 19,
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);
    officesLayer = L.layerGroup().addTo(map);

    function setPoint(latitude, longitude, moveMap) {
        var point = [Number(latitude), Number(longitude)];
        if (!Number.isFinite(point[0]) || !Number.isFinite(point[1])) return;
        if (selectedMarker) selectedMarker.setLatLng(point);
        else selectedMarker = L.marker(point, { draggable: true }).addTo(map);
        selectedMarker.bindPopup("Selected water sampling point");
        if (moveMap) map.setView(point, 16);
        lat.value = point[0].toFixed(6);
        lng.value = point[1].toFixed(6);
        selectedMarker.off("dragend").on("dragend", function (event) {
            var p = event.target.getLatLng();
            lat.value = p.lat.toFixed(6);
            lng.value = p.lng.toFixed(6);
        });
    }
    window.updateSampleMapPoint = setPoint;

    map.on("click", function (event) {
        setPoint(event.latlng.lat, event.latlng.lng, false);
        status.textContent = "Map point selected. Check that the marker is on the exact tap, well, or water collection point.";
    });
    function syncMarker() {
        if (lat.value && lng.value) setPoint(lat.value, lng.value, false);
    }
    lat.addEventListener("change", syncMarker);
    lng.addEventListener("change", syncMarker);

    function loadPin() {
        var code = pin.value.trim();
        if (!/^[1-9][0-9]{5}$/.test(code)) {
            status.textContent = "Enter a valid 6-digit Indian PIN code first.";
            pin.focus();
            return;
        }
        find.disabled = true;
        officeSelect.disabled = true;
        officeSelect.innerHTML = "<option value=\"\">Searching local PIN dataset…</option>";
        status.textContent = "Searching the bundled India Post office-coordinate data. Your PIN stays in this app.";
        if (!datasetPromise) {
            datasetPromise = fetch(host.getAttribute("data-pincode-dataset"))
                .then(function (response) {
                    if (!response.ok) throw new Error("PIN dataset could not be loaded.");
                    return response.json();
                });
        }
        datasetPromise.then(function (rows) {
            var points = rows.filter(function (office) { return office.pin === code; });
            officesLayer.clearLayers();
            officeSelect.innerHTML = "";
            if (!points.length) throw new Error("No mapped post-office point is available for this PIN in the bundled dataset. Enter or capture the exact coordinates manually.");
            points.forEach(function (office, index) {
                var label = office.name + " · " + office.district + ", " + office.state;
                var option = document.createElement("option");
                option.value = String(index);
                option.textContent = label;
                officeSelect.appendChild(option);
                L.circleMarker([office.lat, office.lng], {
                    radius: 6, color: "#63c9e7", fillColor: "#123d52", fillOpacity: 0.9, weight: 2
                }).bindPopup(label + "<br>Post-office reference only; select the actual test point.")
                  .addTo(officesLayer);
            });
            officeSelect.disabled = false;
            officeSelect._pinPoints = points;
            var bounds = L.latLngBounds(points.map(function (office) { return [office.lat, office.lng]; }));
            map.fitBounds(bounds.pad(0.35), { maxZoom: 14 });
            status.textContent = "Found " + points.length + " post-office reference point(s) for PIN " + code
                + ". This is an approximate postal area. Click the exact water source on the map.";
        }).catch(function (error) {
            officeSelect.innerHTML = "<option value=\"\">No mapped post offices found</option>";
            status.textContent = error.message;
        }).finally(function () { find.disabled = false; });
    }
    find.addEventListener("click", loadPin);
    pin.addEventListener("keydown", function (event) {
        if (event.key === "Enter") { event.preventDefault(); loadPin(); }
    });
    officeSelect.addEventListener("change", function () {
        var office = officeSelect._pinPoints && officeSelect._pinPoints[Number(officeSelect.value)];
        if (!office) return;
        map.setView([office.lat, office.lng], 15);
        status.textContent = office.name + " is a postal reference point, not the water sample point. Click the exact source on the map.";
    });
    window.setTimeout(function () { map.invalidateSize(); }, 250);
});
