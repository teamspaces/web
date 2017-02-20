import "../../../node_modules/raven-js/dist/raven.js"
import "./vendor.js"
import "./raven.js"

window.Spaces = {
  Editor: require('./editor'),
  PageHierarchy: require('./page_hierarchy'),
  PageTree: require('./page_tree')
};
