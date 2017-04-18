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