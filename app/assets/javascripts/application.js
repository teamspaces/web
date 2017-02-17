window.$ = window.jQuery = require('jquery');
window._ = require('lodash');

require('jquery-ujs');

Raven.config('https://b99292122b504737bdd0f72a5fe3757e@sentry.io/122307').install();

window.Spaces = {
  Editor: require('./editor')
};

