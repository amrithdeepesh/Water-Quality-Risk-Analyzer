"use strict";

document.addEventListener("DOMContentLoaded", function () {
    const registerForm = document.getElementById("register-form");
    const loginForm = document.getElementById("login-form");
    const query = new URLSearchParams(window.location.search);

    if (registerForm) {
        registerForm.addEventListener("submit", handleRegistration);

        const error = query.get("error");
        const messages = {
            "password-mismatch": "Passwords do not match.",
            "duplicate": "That username is already registered.",
            "invalid": "Enter a username of at least 3 characters and a password of at least 6 characters."
        };

        if (messages[error]) {
            showMessage(
                document.getElementById("register-message"),
                messages[error],
                "error"
            );
        }
    }

    if (loginForm) {
        loginForm.addEventListener("submit", handleLogin);

        if (query.get("registered") === "1") {
            showMessage(
                document.getElementById("login-message"),
                "Registration successful. You can now log in.",
                "success"
            );
        }
        if (query.get("error") === "invalid-credentials") {
            showMessage(
            document.getElementById("login-message"),
            "Incorrect username or password.",
            "error"
            );
        }
        
        if (query.get("error") === "login-required") {
        showMessage(
            document.getElementById("login-message"),
            "Please log in to view the dashboard.",
            "error"
        );
        }

        if (query.get("logout") === "1") {
            showMessage(
                document.getElementById("login-message"),
                "You have been logged out.",
                "success"
            );
        }
    }
});

function handleRegistration(event) {
    event.preventDefault();

    const username = document.getElementById("register-username").value.trim();
    const password = document.getElementById("register-password").value;
    const confirmPassword = document.getElementById("confirm-password").value;
    const message = document.getElementById("register-message");

    const validationMessage =
        validateRegistration(username, password, confirmPassword);

    if (validationMessage) {
        showMessage(message, validationMessage, "error");
        return;
    }

    event.currentTarget.submit();
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

    event.currentTarget.submit();
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
