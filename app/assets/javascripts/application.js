import Editor from './editor'
import Page from './page'
import PageStatusMessage from './page/status_message'
import PageTitle from './page/title'
import PageTree from './PageTree'
import PageHierarchy from './PageHierarchy'
import Dropdowns from './dropdowns'
import SpaceSidebar from './SpaceSidebar'
import tippy from 'tippy.js/dist/tippy'

window.Spaces = {
  Editor: Editor,
  Page: Page,
  PageStatusMessage: PageStatusMessage,
  PageTitle: PageTitle,
  PageTree: PageTree,
  PageHierarchy: PageHierarchy,
  SpaceSidebar: SpaceSidebar
}

const dropdowns = new Dropdowns()

// Tooltips
$(function() {
  tippy('.tippy', {
    position: 'top',
    arrow: true,
    arrowSize: 'small',
    animation: 'shift',
    delay: [100, 0],
    size: 'regular',
    theme: 'spaces',
    sticky: true,
    animateFill: false,
    zIndex: 99
  })
})
