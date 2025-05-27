// This script is responsible for loading the Flutter app in a way that ensures
// network requests are properly handled

// Set up global error handling for network issues
window.addEventListener("error", function (e) {
  // Log network errors but don't block the app
  if (
    e &&
    e.target &&
    (e.target.tagName === "IMG" || e.target.tagName === "SCRIPT")
  ) {
    console.warn("Resource loading error:", e.target.src);
    // Prevent the error from stopping the app
    e.stopPropagation();
    e.preventDefault();
    return true;
  }
});

// Load the main Flutter script
const script = document.createElement("script");
script.src = "main.dart.js";
script.type = "application/javascript";
document.body.appendChild(script);
