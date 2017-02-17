window.$ = window.jQuery = require('jquery');
window._ = require('lodash');
window.hljs = require('highlight.js');
hljs.initHighlightingOnLoad();

require('jquery-ujs');

window.Spaces = {
  Editor: require('./editor')
};
