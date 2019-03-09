var init = function() {
  countChars(500, $('#submission_description'));
  countChars(500, $('#submission_goals'));
  countChars(255, $('#submission_problems'));
  menuCollapse($('#btn-menu'));
}

$(document).on('turbolinks:load', init);
