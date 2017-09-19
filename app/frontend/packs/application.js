/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// javascript
import '../javascripts/helpers'
import Editor from '../javascripts/editor'
import Page from '../javascripts/page'
import PageStatusMessage from '../javascripts/page/status_message'
import PageTitle from '../javascripts/page/title'
import PageTree from '../javascripts/PageTree'
import PageHierarchy from '../javascripts/PageHierarchy'
import SpaceSidebar from '../javascripts/SpaceSidebar'
import Overlays from '../javascripts/Overlays'
import Overflows from '../javascripts/Overflows'
import Tabs from '../javascripts/Tabs'
import InstantSearch from '../javascripts/InstantSearch'

window.Spaces = {
  Editor: Editor,
  Page: Page,
  PageStatusMessage: PageStatusMessage,
  PageTitle: PageTitle,
  PageTree: PageTree,
  PageHierarchy: PageHierarchy,
  SpaceSidebar: SpaceSidebar
}

// Team/account, spaces and share overlays
new Overlays()

// Overflows
new Overflows()

// Tabs
new Tabs()

// Instant search
new InstantSearch({
  input: '.topbar__search-input',
  resultsContainer: '.topbar__search-results',
  clearButton: '.topbar__clear-search',
  showHints: true,
  useFocusShortcut: true
})

// stylesheets
import '../stylesheets/application.scss'

// recursively require images
require.context('../images/static', true)
