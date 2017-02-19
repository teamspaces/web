import "../../../node_modules/raven-js/dist/raven.js"
import "./vendor.js"
import "./raven.js"

window.Spaces = {
  Editor: require('./editor'),
  Page: require('./page'),
  PageTitle: require('./page/title')
};
