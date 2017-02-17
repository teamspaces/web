window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');
require('jquery-ui-bundle');

window.Spaces = {
  Editor: require('./editor'),
  Space: require('./space'),
  PageTree: require('./page_tree')
};
