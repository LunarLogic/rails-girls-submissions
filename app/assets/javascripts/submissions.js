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

$(document).on('turbolinks:load', setRating);
$(document).on('turbolinks:load', submitRating);
