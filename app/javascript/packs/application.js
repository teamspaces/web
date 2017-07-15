/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

console.log('Hello World from Webpacker');


import Editor from '../javascripts/editor'
import Page from '../javascripts/page'
import PageStatusMessage from '../javascripts/page/status_message'
import PageTitle from '../javascripts/page/title'
import PageTree from '../javascripts/page_tree'
import PageHierarchy from '../javascripts/page_hierarchy'
import Dropdowns from '../javascripts/dropdowns'

window.Spaces = {
  Editor: Editor,
  Page: Page,
  PageStatusMessage: PageStatusMessage,
  PageTitle: PageTitle,
  PageTree: PageTree,
  PageHierarchy: PageHierarchy
};

const dropdowns = new Dropdowns()


import '../stylesheets/application.scss';

import '../static/default_space_cover.jpg';
import '../static/default_team_logo.jpg';
import '../static/default_user_avatar.jpg';
