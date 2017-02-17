window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

if(process.env.PRODUCTION){
  window.Raven = require('../../../node_modules/raven-js/dist/raven.js');
  Raven.config(process.env.SENTRY_DSN).install();
}

window.Spaces = {
  Editor: require('./editor')
};
