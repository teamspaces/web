/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

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

// stylesheets
import '../stylesheets/application.scss'

// images
import '../static/default_space_cover.jpg'
import '../static/default_team_logo.jpg'
import '../static/default_user_avatar.jpg'
import '../static/spaces-logo.svg'
