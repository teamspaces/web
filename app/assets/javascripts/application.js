window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

window.Spaces = {
  Editor: require('./editor'),
  TitleEditor: require('./title_editor')
};
