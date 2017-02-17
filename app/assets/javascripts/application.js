window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');
require('jquery-ui-bundle');

window.Spaces = {
  Editor: require('./editor'),
  Page: require('./page'),
  Space: require('./space'),
  PageTitle: require('./page/title')
};
