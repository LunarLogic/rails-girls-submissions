var init = function() {
  var countChars = function(limit, element) {
    var textMax = limit;
    var textarea = element;
    var counter = textarea.siblings('.character-counter');

    counter.html(textMax);

    textarea.keyup(function() {
      var textLength = textarea.val().length;
      var textRemaining = textMax - textLength;

      counter.html(textRemaining);
    });
  };

  countChars(255, $('#submission_description'));
  countChars(255, $('#submission_goals'));
  countChars(255, $('#submission_problems'));
}

$(document).ready(init);