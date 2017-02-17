window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

Raven.config().install();

window.Spaces = {
  Editor: require('./editor')
};

