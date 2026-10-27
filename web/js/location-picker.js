"use strict";

document.addEventListener("DOMContentLoaded", function () {
    var host = document.getElementById("sample-location-map");
    var pin = document.getElementById("pincode");
    var find = document.getElementById("locate-pincode");
    var officeSelect = document.getElementById("pin-office");
    var status = document.getElementById("pin-status");
    var lat = document.getElementById("latitude");
    var lng = document.getElementById("longitude");
    var stateSelect = document.getElementById("state");
    var map, selectedMarker, officesLayer, datasetPromise;

    var PIN_REGIONS = {
        "11": { name: "Delhi NCR (New Delhi)", lat: 28.6139, lng: 77.2090, zoom: 13 },
        "12": { name: "Haryana (Gurugram / Faridabad)", lat: 28.4595, lng: 77.0266, zoom: 12 },
        "13": { name: "Haryana (Ambala / Karnal / Panipat)", lat: 30.3782, lng: 76.7767, zoom: 12 },
        "14": { name: "Punjab (Amritsar / Jalandhar / Ludhiana)", lat: 31.6340, lng: 74.8723, zoom: 12 },
        "15": { name: "Punjab (Bathinda / Firozpur / Patiala)", lat: 30.2110, lng: 74.9455, zoom: 12 },
        "16": { name: "Chandigarh", lat: 30.7333, lng: 76.7794, zoom: 13 },
        "17": { name: "Himachal Pradesh (Shimla / Dharamshala)", lat: 31.1048, lng: 77.1734, zoom: 12 },
        "18": { name: "Jammu Region", lat: 32.7266, lng: 74.8570, zoom: 12 },
        "19": { name: "Kashmir Valley (Srinagar)", lat: 34.0837, lng: 74.7973, zoom: 12 },
        "20": { name: "Western UP (Aligarh / Agra / Mathura)", lat: 27.8974, lng: 78.0880, zoom: 12 },
        "21": { name: "Southern UP (Prayagraj / Fatehpur)", lat: 25.4358, lng: 81.8463, zoom: 12 },
        "22": { name: "Central UP (Lucknow / Ayodhya)", lat: 26.8467, lng: 80.9462, zoom: 12 },
        "23": { name: "Eastern UP (Varanasi / Mirzapur)", lat: 25.3176, lng: 82.9739, zoom: 12 },
        "24": { name: "Uttarakhand (Dehradun / Haridwar)", lat: 30.3165, lng: 78.0322, zoom: 12 },
        "25": { name: "Western UP (Meerut / Ghaziabad / Noida)", lat: 28.9845, lng: 77.7064, zoom: 12 },
        "26": { name: "Northern UP (Bareilly / Pilibhit)", lat: 28.3670, lng: 79.4304, zoom: 12 },
        "27": { name: "Eastern UP (Gorakhpur / Basti)", lat: 26.7606, lng: 83.3732, zoom: 12 },
        "28": { name: "Bundelkhand UP (Jhansi / Lalitpur)", lat: 25.4484, lng: 78.5685, zoom: 12 },
        "30": { name: "Rajasthan (Jaipur / Ajmer)", lat: 26.9124, lng: 75.7873, zoom: 12 },
        "31": { name: "Rajasthan (Udaipur / Chittorgarh)", lat: 24.5854, lng: 73.7125, zoom: 12 },
        "32": { name: "Rajasthan (Kota / Bharatpur)", lat: 25.2138, lng: 75.8648, zoom: 12 },
        "33": { name: "Rajasthan (Bikaner / Sri Ganganagar)", lat: 28.0229, lng: 73.3119, zoom: 12 },
        "34": { name: "Rajasthan (Jodhpur / Barmer)", lat: 26.2389, lng: 73.0243, zoom: 12 },
        "36": { name: "Gujarat (Rajkot / Jamnagar)", lat: 22.3039, lng: 70.8022, zoom: 12 },
        "37": { name: "Gujarat (Kutch / Bhuj)", lat: 23.2420, lng: 69.6669, zoom: 12 },
        "38": { name: "Gujarat (Ahmedabad / Gandhinagar)", lat: 23.0225, lng: 72.5714, zoom: 12 },
        "39": { name: "Gujarat (Surat / Vadodara)", lat: 21.1702, lng: 72.8311, zoom: 12 },
        "40": { name: "Mumbai / Thane / Navi Mumbai", lat: 19.0760, lng: 72.8777, zoom: 13 },
        "41": { name: "Maharashtra (Pune / Solapur)", lat: 18.5204, lng: 73.8567, zoom: 12 },
        "42": { name: "Maharashtra (Nashik / Dhule)", lat: 19.9975, lng: 73.7898, zoom: 12 },
        "43": { name: "Maharashtra (Chhatrapati Sambhajinagar)", lat: 19.8762, lng: 75.3433, zoom: 12 },
        "44": { name: "Maharashtra (Nagpur / Amravati)", lat: 21.1458, lng: 79.0882, zoom: 12 },
        "45": { name: "Madhya Pradesh (Indore / Ujjain)", lat: 22.7196, lng: 75.8577, zoom: 12 },
        "46": { name: "Madhya Pradesh (Bhopal)", lat: 23.2599, lng: 77.4126, zoom: 12 },
        "47": { name: "Madhya Pradesh (Gwalior)", lat: 26.2183, lng: 78.1828, zoom: 12 },
        "48": { name: "Madhya Pradesh (Jabalpur)", lat: 23.1815, lng: 79.9864, zoom: 12 },
        "49": { name: "Chhattisgarh (Raipur / Bilaspur)", lat: 21.2514, lng: 81.6296, zoom: 12 },
        "50": { name: "Telangana (Hyderabad / Secunderabad)", lat: 17.3850, lng: 78.4867, zoom: 13 },
        "51": { name: "Andhra Pradesh (Tirupati / Kurnool)", lat: 13.6288, lng: 79.4192, zoom: 12 },
        "52": { name: "Andhra Pradesh (Vijayawada / Guntur)", lat: 16.5062, lng: 80.6480, zoom: 12 },
        "53": { name: "Andhra Pradesh (Visakhapatnam)", lat: 17.6868, lng: 83.2185, zoom: 12 },
        "56": { name: "Karnataka (Bengaluru Urban & Rural)", lat: 12.9716, lng: 77.5946, zoom: 13 },
        "57": { name: "Karnataka (Mysuru / Mangaluru)", lat: 12.2958, lng: 76.6394, zoom: 12 },
        "58": { name: "Karnataka (Hubballi-Dharwad / Belagavi)", lat: 15.3647, lng: 75.1240, zoom: 12 },
        "59": { name: "Karnataka (Kalaburagi / Ballari)", lat: 17.3297, lng: 76.8343, zoom: 12 },
        "60": { name: "Tamil Nadu (Chennai & Kanchipuram)", lat: 13.0827, lng: 80.2707, zoom: 13 },
        "61": { name: "Tamil Nadu (Tiruchirappalli / Thanjavur)", lat: 10.7905, lng: 78.7047, zoom: 12 },
        "62": { name: "Tamil Nadu (Madurai / Tirunelveli)", lat: 9.9252, lng: 78.1198, zoom: 12 },
        "63": { name: "Tamil Nadu (Salem / Erode / Vellore)", lat: 11.6643, lng: 78.1460, zoom: 12 },
        "64": { name: "Tamil Nadu (Coimbatore / Tiruppur)", lat: 11.0168, lng: 76.9558, zoom: 12 },
        "67": { name: "Kerala (Kozhikode / Kannur / Malappuram)", lat: 11.2588, lng: 75.7804, zoom: 12 },
        "68": { name: "Kerala (Kochi / Ernakulam / Thrissur)", lat: 9.9312, lng: 76.2673, zoom: 12 },
        "69": { name: "Kerala (Thiruvananthapuram / Kollam)", lat: 8.5241, lng: 76.9366, zoom: 12 },
        "70": { name: "West Bengal (Kolkata & Howrah)", lat: 22.5726, lng: 88.3639, zoom: 13 },
        "71": { name: "West Bengal (Hooghly / Burdwan)", lat: 22.9012, lng: 88.3976, zoom: 12 },
        "72": { name: "West Bengal (Medinipur / Kharagpur)", lat: 22.4257, lng: 87.3199, zoom: 12 },
        "73": { name: "West Bengal (Siliguri / Darjeeling)", lat: 26.7271, lng: 88.3953, zoom: 12 },
        "74": { name: "West Bengal (North 24 Parganas / Nadia)", lat: 22.7186, lng: 88.4779, zoom: 12 },
        "75": { name: "Odisha (Bhubaneswar / Cuttack / Puri)", lat: 20.2961, lng: 85.8245, zoom: 12 },
        "76": { name: "Odisha (Berhampur / Ganjam)", lat: 19.3149, lng: 84.7941, zoom: 12 },
        "77": { name: "Odisha (Rourkela / Sambalpur)", lat: 22.2604, lng: 84.8536, zoom: 12 },
        "78": { name: "Assam (Guwahati / Dibrugarh)", lat: 26.1445, lng: 91.7362, zoom: 12 },
        "79": { name: "North-East (Shillong / Agartala / Imphal)", lat: 25.5788, lng: 91.8933, zoom: 12 },
        "80": { name: "Bihar (Patna / Gaya / Nalanda)", lat: 25.5941, lng: 85.1376, zoom: 12 },
        "81": { name: "Bihar (Bhagalpur / Munger)", lat: 25.2425, lng: 86.9842, zoom: 12 },
        "82": { name: "Jharkhand & Bihar (Dhanbad / Bokaro)", lat: 23.7957, lng: 86.4304, zoom: 12 },
        "83": { name: "Jharkhand (Ranchi / Jamshedpur)", lat: 23.3441, lng: 85.3096, zoom: 12 },
        "84": { name: "Bihar (Muzaffarpur / Darbhanga)", lat: 26.1209, lng: 85.3647, zoom: 12 },
        "85": { name: "Bihar (Purnia / Katihar)", lat: 25.7771, lng: 87.4753, zoom: 12 }
    };

    if (!host || typeof L === "undefined") {
        if (status) status.textContent = "Location map is currently unavailable. Coordinates can be entered manually.";
        return;
    }

    map = L.map(host, { scrollWheelZoom: true, dragging: true, touchZoom: true, doubleClickZoom: true })
        .setView([20.5937, 78.9629], 5);

    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
        maxZoom: 19,
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);

    officesLayer = L.layerGroup().addTo(map);

    function setPoint(latitude, longitude, moveMap, zoomLevel) {
        var point = [Number(latitude), Number(longitude)];
        if (!Number.isFinite(point[0]) || !Number.isFinite(point[1])) return;

        if (selectedMarker) {
            selectedMarker.setLatLng(point);
        } else {
            selectedMarker = L.marker(point, { draggable: true }).addTo(map);
        }

        selectedMarker.bindPopup("<strong>Selected Water Sampling Point</strong><br>Lat: " + point[0].toFixed(6) + "<br>Lng: " + point[1].toFixed(6));

        if (moveMap) {
            map.setView(point, zoomLevel || 15);
        }

        if (lat) lat.value = point[0].toFixed(6);
        if (lng) lng.value = point[1].toFixed(6);

        selectedMarker.off("dragend").on("dragend", function (event) {
            var p = event.target.getLatLng();
            if (lat) lat.value = p.lat.toFixed(6);
            if (lng) lng.value = p.lng.toFixed(6);
            if (status) status.textContent = "Marker updated! Sampling coordinates set to " + p.lat.toFixed(6) + ", " + p.lng.toFixed(6);
        });
    }

    window.updateSampleMapPoint = setPoint;

    map.on("click", function (event) {
        setPoint(event.latlng.lat, event.latlng.lng, false);
        if (status) {
            status.textContent = "Water point selected! Coordinates set to " + event.latlng.lat.toFixed(6) + ", " + event.latlng.lng.toFixed(6);
        }
    });

    function syncMarker() {
        if (lat && lng && lat.value && lng.value) {
            setPoint(lat.value, lng.value, false);
        }
    }
    if (lat) lat.addEventListener("change", syncMarker);
    if (lng) lng.addEventListener("change", syncMarker);

    function loadPin() {
        if (!pin) return;
        var code = pin.value.trim();

        if (!/^[1-9][0-9]{5}$/.test(code)) {
            if (status) {
                status.textContent = "Please enter a valid 6-digit Indian PIN code (e.g., 560001, 110001).";
            }
            pin.focus();
            pin.style.borderColor = "#ff9daa";
            setTimeout(function () { pin.style.borderColor = ""; }, 2500);
            return;
        }

        if (find) find.disabled = true;
        if (officeSelect) {
            officeSelect.disabled = true;
            officeSelect.innerHTML = "<option value=\"\">Locating PIN area " + code + "…</option>";
        }
        if (status) {
            status.textContent = "Locating postal area for PIN " + code + "…";
        }

        if (!datasetPromise) {
            var datasetUrl = host.getAttribute("data-pincode-dataset") || "data/india-pincode-offices.json";
            datasetPromise = fetch(datasetUrl)
                .then(function (response) {
                    if (!response.ok) throw new Error("Dataset response failed");
                    return response.json();
                })
                .catch(function () {
                    return [];
                });
        }

        datasetPromise.then(function (rows) {
            var points = Array.isArray(rows) ? rows.filter(function (office) { return office.pin === code; }) : [];
            officesLayer.clearLayers();

            if (points.length > 0) {
                if (officeSelect) {
                    officeSelect.innerHTML = "";
                    points.forEach(function (office, index) {
                        var label = office.name + " (" + office.district + ", " + office.state + ")";
                        var option = document.createElement("option");
                        option.value = String(index);
                        option.textContent = label;
                        officeSelect.appendChild(option);

                        L.circleMarker([office.lat, office.lng], {
                            radius: 7, color: "#36c4d0", fillColor: "#0b2b36", fillOpacity: 0.9, weight: 2
                        }).bindPopup("<strong>" + office.name + "</strong><br>" + office.district + ", " + office.state)
                          .addTo(officesLayer);
                    });
                    officeSelect.disabled = false;
                    officeSelect._pinPoints = points;
                }

                var firstOffice = points[0];
                setPoint(firstOffice.lat, firstOffice.lng, true, 14);

                if (status) {
                    status.textContent = "Found " + points.length + " post office reference point(s) for PIN " + code + ". Marker placed on map. Drag or click map to fine-tune exact tap/well location.";
                }
            } else {
                var prefix = code.slice(0, 2);
                var region = PIN_REGIONS[prefix];

                if (!region) {
                    var zone = code.charAt(0);
                    var fallbackLat = 20.5937, fallbackLng = 78.9629, fallbackName = "India (Zone " + zone + ")";
                    if (zone === "1" || zone === "2") { fallbackLat = 27.5; fallbackLng = 78.5; }
                    else if (zone === "3") { fallbackLat = 25.5; fallbackLng = 72.5; }
                    else if (zone === "4") { fallbackLat = 20.5; fallbackLng = 76.5; }
                    else if (zone === "5") { fallbackLat = 15.0; fallbackLng = 77.5; }
                    else if (zone === "6") { fallbackLat = 10.5; fallbackLng = 77.5; }
                    else if (zone === "7") { fallbackLat = 24.5; fallbackLng = 88.5; }
                    else if (zone === "8") { fallbackLat = 24.5; fallbackLng = 85.5; }
                    region = { name: fallbackName, lat: fallbackLat, lng: fallbackLng, zoom: 11 };
                }

                setPoint(region.lat, region.lng, true, region.zoom || 12);

                if (officeSelect) {
                    officeSelect.innerHTML = "<option value=\"0\">" + region.name + " (PIN area " + code + ")</option>";
                    officeSelect.disabled = false;
                    officeSelect._pinPoints = [{ name: region.name, lat: region.lat, lng: region.lng }];
                }

                if (status) {
                    status.textContent = "Area located: " + region.name + " for PIN " + code + ". Marker placed on map! Click anywhere on the map to pinpoint your exact water source.";
                }
            }
        }).catch(function (error) {
            if (status) {
                status.textContent = "Could not load postal data. Click on the map to place the sampling point manually.";
            }
        }).finally(function () {
            if (find) find.disabled = false;
        });
    }

    window.triggerPinLookup = loadPin;

    if (find) {
        find.addEventListener("click", loadPin);
    }

    if (pin) {
        pin.addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault();
                loadPin();
            }
        });

        pin.addEventListener("input", function () {
            var val = pin.value.trim();
            if (/^[1-9][0-9]{5}$/.test(val)) {
                loadPin();
            }
        });

        pin.addEventListener("change", function () {
            var val = pin.value.trim();
            if (/^[1-9][0-9]{5}$/.test(val)) {
                loadPin();
            }
        });
    }

    if (officeSelect) {
        officeSelect.addEventListener("change", function () {
            var pts = officeSelect._pinPoints;
            if (!pts || !pts.length) return;
            var idx = Number(officeSelect.value);
            var office = pts[idx];
            if (!office) return;
            setPoint(office.lat, office.lng, true, 15);
            if (status) {
                status.textContent = "Reference set to " + office.name + ". Click or drag the marker to your actual water tap/well.";
            }
        });
    }

    window.setTimeout(function () {
        if (map) map.invalidateSize();
    }, 300);
});
