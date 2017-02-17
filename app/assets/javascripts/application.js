window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

window.Raven = require('../../../node_modules/raven-js/dist/raven.js');



Raven.config(process.env.SENTRY).install();

window.Spaces = {
  Editor: require('./editor')
};

