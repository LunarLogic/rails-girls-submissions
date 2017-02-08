var ready = function() {
  var rate = $('#js-user-rating').data('rate');
  document.getElementById("value_" + rate).checked = true;
};

if(window.location.pathname.match(/\/admin\/submissions\/\d*$/)) {
  $(document).on('page:change', ready);
}
