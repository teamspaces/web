import './helpers'
import Editor from './editor'
import Page from './page'
import PageStatusMessage from './page/status_message'
import PageTitle from './page/title'
import PageTree from './PageTree'
import PageHierarchy from './PageHierarchy'
import SpaceSidebar from './SpaceSidebar'
import Overlays from './Overlays'
import Overflows from './Overflows'
import Tabs from './Tabs'
import InstantSearch from './InstantSearch'

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
  clearButton: '',
  showHints: true
})
