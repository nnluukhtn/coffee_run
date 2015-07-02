$(document).ready(function(e) {
  var offset = - new Date().getTimezoneOffset()/60
  $.cookie("browser.tzoffset", offset, { expires: 30, path: '/' })
});
