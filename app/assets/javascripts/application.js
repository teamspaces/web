import Editor from './editor'
import Page from './page'
import PageStatusMessage from './page/status_message'
import PageTitle from './page/title'
import PageTree from './page_tree'
import PageHierarchy from './page_hierarchy'
import Dropdowns from './dropdowns'

window.Spaces = {
  Editor: Editor,
  Page: Page,
  PageStatusMessage: PageStatusMessage,
  PageTitle: PageTitle,
  PageTree: PageTree,
  PageHierarchy: PageHierarchy
};

const dropdowns = new Dropdowns()
