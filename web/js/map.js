"use strict";

document.addEventListener("DOMContentLoaded", function () {
    var host = document.getElementById("india-water-map");
    if (!host) return;
    var message = document.getElementById("map-message");
    var badge = document.getElementById("map-source-badge");
    var count = document.getElementById("visible-count");
    var sourceFilter = document.getElementById("source-filter");
    var riskFilter = document.getElementById("risk-filter");
    var dateFilter = document.getElementById("date-filter");
    var samples = [];
    var markers;

    if (typeof L === "undefined") {
        badge.textContent = "Map library unavailable";
        message.textContent = "The map library could not load. Check your internet connection and reload.";
        return;
    }

    var map = L.map(host, { scrollWheelZoom: true, dragging: true, touchZoom: true, doubleClickZoom: true, keyboard: true }).setView([22.7, 79.0], 4.5);
    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
        maxZoom: 18,
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap contributors</a>'
    }).addTo(map);
    markers = L.layerGroup().addTo(map);

    function escapeHtml(value) {
        return String(value == null ? "" : value).replace(/[&<>"']/g, function (ch) {
            return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[ch];
        });
    }

    function colorFor(risk) {
        return {
            safe: "#35c99a",
            moderate: "#f2bf55",
            high: "#ff8b5e",
            critical: "#ff5b72"
        }[String(risk || "").toLowerCase()] || "#68b9dc";
    }

    function visibleSamples() {
        var risk = riskFilter.value;
        var source = sourceFilter.value;
        var days = dateFilter.value;
        var cutoff = days === "all" ? null : new Date();
        if (cutoff) cutoff.setDate(cutoff.getDate() - Number(days));
        return samples.filter(function (sample) {
            if (risk !== "all" && String(sample.risk).toLowerCase() !== risk) return false;
            if (source !== "all" && sample.source !== source) return false;
            if (cutoff && new Date(sample.date + "T00:00:00") < cutoff) return false;
            return Number.isFinite(Number(sample.lat)) && Number.isFinite(Number(sample.lng));
        });
    }

    function render() {
        var shown = visibleSamples();
        markers.clearLayers();
        shown.forEach(function (sample) {
            var marker = L.circleMarker([Number(sample.lat), Number(sample.lng)], {
                radius: 7 + Math.max(0, Math.min(100, Number(sample.score) || 0)) / 18,
                color: colorFor(sample.risk),
                weight: 2,
                fillColor: colorFor(sample.risk),
                fillOpacity: 0.72
            });
            var origin = sample.demo ? "Synthetic demonstration sample" : "Anonymous user-shared sample";
            marker.bindPopup(
                "<strong>" + escapeHtml(sample.city) + ", " + escapeHtml(sample.state) + "</strong><br>"
                + escapeHtml(sample.source) + " · " + escapeHtml(sample.date) + "<br>"
                + "Project risk: " + escapeHtml(sample.risk) + " (" + escapeHtml(sample.score) + "/100)<br>"
                + "Test point: " + Number(sample.lat).toFixed(6) + ", " + Number(sample.lng).toFixed(6) + "<br>"
                + "<small>" + origin + "</small>"
            );
            markers.addLayer(marker);
        });
        count.textContent = shown.length;
        message.textContent = shown.length
            ? "Showing " + shown.length + " sample locations. Select a circle for details."
            : "No samples match these filters.";
    }

    function setSamples(payload, fallback) {
        var rows = Array.isArray(payload) ? payload : payload.samples;
        samples = Array.isArray(rows) ? rows : [];
        var sourceName = fallback || (payload.source === "mysql" ? "MySQL data" : "Demo data");
        badge.textContent = sourceName;
        var seen = {};
        samples.forEach(function (sample) {
            if (sample.source && !seen[sample.source]) {
                seen[sample.source] = true;
                var option = document.createElement("option");
                option.value = sample.source;
                option.textContent = sample.source;
                sourceFilter.appendChild(option);
            }
        });
        render();
        if (samples.length) {
            var bounds = L.latLngBounds(samples.map(function (sample) {
                return [Number(sample.lat), Number(sample.lng)];
            }));
            if (bounds.isValid()) map.fitBounds(bounds.pad(0.08), { maxZoom: 5 });
        }
        window.setTimeout(function () { map.invalidateSize(); }, 100);
    }

    [riskFilter, sourceFilter, dateFilter].forEach(function (control) {
        control.addEventListener("change", render);
    });

    fetch(host.getAttribute("data-endpoint"), { credentials: "same-origin" })
        .then(function (response) {
            if (!response.ok) throw new Error("Map endpoint unavailable");
            return response.json();
        })
        .then(function (payload) { setSamples(payload, null); })
        .catch(function () {
            return fetch(host.getAttribute("data-fallback"))
                .then(function (response) {
                    if (!response.ok) throw new Error("Demo samples unavailable");
                    return response.json();
                })
                .then(function (rows) { setSamples(rows, "Demo data (offline fallback)"); })
                .catch(function () {
                    badge.textContent = "No sample data";
                    message.textContent = "The map sample data could not be loaded.";
                });
        });
});
