window._ = require('lodash');

window.$ = window.jQuery = require('jquery');
require('jquery-ujs');

window.hljs = require('highlight.js');
hljs.initHighlightingOnLoad();

import "../../../node_modules/raven-js/dist/raven.js"
import "./raven.js"

window.Spaces = {
  Editor: require('./editor')
};
