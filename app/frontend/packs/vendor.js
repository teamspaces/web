window._ = require('lodash')

window.$ = window.jQuery = require('jquery')
require('jquery-ujs')
require('jquery-ui-bundle')

// Adding path as the main path is incorrect in the package
require('../../../vendor/assets/javascripts/jquery.mjs.nestedSortable.js')

window.hljs = require('highlight.js')
hljs.initHighlightingOnLoad()

import "../../../node_modules/raven-js/dist/raven.js"
import "../javascripts/sentry.js"

// Adding path as the main path is incorrect in the package
require('sticky-kit/dist/sticky-kit.js');
