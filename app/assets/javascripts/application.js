window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

window.Spaces = {
  Editor: require('./editor'),
  Page: require('./page'),
  TitleEditor: require('./title_editor')
};
