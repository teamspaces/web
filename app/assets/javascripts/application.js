window._ = require('lodash')

window.$ = window.jQuery = require('jquery')
require('jquery-ujs')
require('jquery-ui-bundle')

window.hljs = require('highlight.js')
hljs.initHighlightingOnLoad()

import "../../../node_modules/raven-js/dist/raven.js"
import "./raven.js"

// Adding the path here as the main path is incorrect in the package
require('sticky-kit/dist/sticky-kit.js');

const Editor = require('./editor')

import Page from './page'
import PageSavingStatus from './page/saving_status'
import PageTitle from './page/title'
import PageTree from './page_tree'
import PageHierarchy from './page_hierarchy'

window.Spaces = {
  Editor: Editor,
  Page: Page,
  PageSavingStatus: PageSavingStatus,
  PageTitle: PageTitle,
  PageTree: PageTree,
  PageHierarchy: PageHierarchy
};
