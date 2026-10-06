(function () {
    "use strict";

    if (window.location.protocol !== "file:") {
        return;
    }

    var page = window.location.pathname.split("/").pop().toLowerCase();
    var allowedPages = {
        "index.html": true,
        "login.html": true,
        "register.html": true
    };

    if (!allowedPages[page]) {
        page = "index.html";
    }

    window.location.replace(
        "http://localhost:8081/WaterQualityRiskAnalyzer/"
        + page + window.location.search + window.location.hash
    );
}());
