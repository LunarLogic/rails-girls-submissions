var rating_handler = function() {
  var rate = $('#user-rating').data('rate');
  document.getElementById("value_" + rate).checked = true;
}

$(document).on('page:change', rating_handler);
