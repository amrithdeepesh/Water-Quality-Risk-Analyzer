"use strict";

document.addEventListener("DOMContentLoaded", function () {
    const registerForm = document.getElementById("register-form");
    const loginForm = document.getElementById("login-form");

    if (registerForm) {
        registerForm.addEventListener("submit", handleRegistration);
    }

    if (loginForm) {
        loginForm.addEventListener("submit", handleLogin);
    }
});

function handleRegistration(event) {
    event.preventDefault();

    const username = document.getElementById("register-username").value.trim();
    const password = document.getElementById("register-password").value;
    const confirmPassword = document.getElementById("confirm-password").value;
    const message = document.getElementById("register-message");

    const validationMessage = validateRegistration(username, password, confirmPassword);
    if (validationMessage) {
        showMessage(message, validationMessage, "error");
        return;
    }

    const userJson = JSON.stringify({ username: username, password: password });
    const userData = JSON.parse(userJson);
    showMessage(message, "Registration successful for " + userData.username + ". User data was created as JSON.", "success");
}

function handleLogin(event) {
    event.preventDefault();

    const username = document.getElementById("login-username").value.trim();
    const password = document.getElementById("login-password").value;
    const message = document.getElementById("login-message");

    const validationMessage = validateLogin(username, password);
    if (validationMessage) {
        showMessage(message, validationMessage, "error");
        return;
    }

    const userJson = JSON.stringify({ username: username, password: password });
    const userData = JSON.parse(userJson);
    showMessage(message, "Login submitted successfully for " + userData.username + ".", "success");
}

function validateRegistration(username, password, confirmPassword) {
    const loginError = validateLogin(username, password);

    if (loginError) {
        return loginError;
    }

    if (!confirmPassword) {
        return "Please confirm your password.";
    }

    if (password !== confirmPassword) {
        return "Password and confirm password must match.";
    }

    return "";
}

function validateLogin(username, password) {
    if (!username || !password) {
        return "Username and password cannot be empty.";
    }

    if (username.length < 3) {
        return "Username must contain at least 3 characters.";
    }

    if (password.length < 6) {
        return "Password must contain at least 6 characters.";
    }

    return "";
}

function showMessage(messageElement, text, type) {
    messageElement.textContent = text;
    messageElement.className = "form-message " + type;
}
