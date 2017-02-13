var setRating = function() {
  if (document.getElementById('js-user-rating')) {
    var rate = $('#js-user-rating').data('rate');
    document.getElementById("value_" + rate).checked = true;
  }
};

$(document).on('page:change', setRating);
