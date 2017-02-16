window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');
require('jquery-ui-bundle');

window.Spaces = {
  Editor: require('./editor'),
  Page: require('./page'),
  PageTitle: require('./page/title')
};
