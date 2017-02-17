window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

var $script = require("scriptjs");
$script("//cdn.ravenjs.com/3.10.0/raven.min.js", function() {
  Raven.config('').install();


window.Spaces = {
  Editor: require('./editor')
};

});

