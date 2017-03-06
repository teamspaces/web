const Editor = require('./editor')

import Page from './page'
import PageSavingStatus from './page/saving_status'
import PageTitle from './page/title'
import PageTree from './page_tree'
import PageHierarchy from './page_hierarchy'
import Dropdowns from './dropdowns'

window.Spaces = {
  Editor: Editor,
  Page: Page,
  PageSavingStatus: PageSavingStatus,
  PageTitle: PageTitle,
  PageTree: PageTree,
  PageHierarchy: PageHierarchy
};

const dropdowns = new Dropdowns()
