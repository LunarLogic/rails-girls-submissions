var menuCollapse = function(button) {
  var menu = document.getElementById('menu');

  button.click(function() {
    this.classList.toggle("btn-menu-active");
    menu.classList.toggle("header-menu-visible");
  });
};