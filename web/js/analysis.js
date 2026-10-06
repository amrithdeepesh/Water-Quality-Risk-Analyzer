"use strict";

document.addEventListener("DOMContentLoaded", function () {
    const panel = document.getElementById("scenario-buttons");
    const form = document.getElementById("analysis-form");
    const message = document.getElementById("scenario-message");
    const date = document.getElementById("collectionDate");
    if (!panel || !form) return;

    const today = new Date();
    date.value = new Date(today.getTime() - today.getTimezoneOffset() * 60000)
        .toISOString().slice(0, 10);

    fetch(panel.getAttribute("data-scenarios"))
        .then(function (response) {
            if (!response.ok) throw new Error("Scenario data unavailable");
            return response.json();
        })
        .then(function (scenarios) {
            scenarios.forEach(function (scenario) {
                const button = document.createElement("button");
                button.type = "button";
                button.className = "scenario-button";
                button.textContent = scenario.label;
                button.addEventListener("click", function () {
                    Object.keys(scenario.values).forEach(function (name) {
                        if (form.elements[name]) {
                            form.elements[name].value = scenario.values[name];
                        }
                    });
                    message.textContent = scenario.label
                        + " loaded. You can edit the values before analysis.";
                });
                panel.appendChild(button);
            });
        })
        .catch(function () {
            message.textContent = "Sample scenarios could not be loaded. Enter values manually.";
        });
});
