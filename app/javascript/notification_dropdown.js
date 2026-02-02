document.addEventListener("turbo:load", () => {
  const bell = document.getElementById("notification-bell");
  const dropdown = document.getElementById("notification-dropdown");

  if (bell) {
    bell.addEventListener("click", (e) => {
      e.preventDefault();
      dropdown.style.display =
        dropdown.style.display === "none" ? "block" : "none";
    });
  }
});
