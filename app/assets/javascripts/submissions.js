var setRating = function() {
  if ($('#js-user-rating').length) {
    var rate = $('#js-user-rating').data('rate');
    if (rate > 0) {
      $("#value_" + rate).prop("checked", true);
    }
  }
};

var submitRating = function() {
  $("#js-user-rating input").change(function() {
    $("#js-submission-rating-form").submit();
  });
};

$(document).on('page:change', setRating);
$(document).on('page:change', submitRating);
