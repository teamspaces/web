import "../../../node_modules/raven-js/dist/raven.js"
import "./vendor.js"
import "./raven.js"

// TODO: Move this to vendor.js?
require('jquery-ui-bundle');

window.Spaces = {
  Editor: require('./editor'),
  PageHierarchy: require('./page_hierarchy'),
  PageTree: require('./page_tree')
};
