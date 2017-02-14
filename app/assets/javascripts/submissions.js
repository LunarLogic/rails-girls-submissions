var setRating = function() {
  if (document.getElementById('js-user-rating')) {
    var rate = $('#js-user-rating').data('rate');
    document.getElementById("value_" + rate).checked = true;
  }
};

var submitRating = function() {
  var labels = $("#js-user-rating label");

  if (labels.length > 0) {
    labels.map(function() {
      this.onclick = function(e) {
        setTimeout(function() {
          var form = document.getElementById("js-submission-rating-form");
          form.submit();
        }, 200);
      };
    });
  }
};

$(document).on('page:change', setRating);
$(document).on('page:change', submitRating);
