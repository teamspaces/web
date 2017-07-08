import $ from 'jquery'
import Ps from 'perfect-scrollbar'

class SpaceSidebar {
  constructor () {
    this.sidebar = null

    // Wait until the dom has loaded
    $(this.onDomLoaded.bind(this))
  }

  onDomLoaded () {
    this.initTree()
    this.addListeners()
  }

  initTree () {
    // Update page tree toggles based on the active page
    $('.page-tree__active').each(function() {
      // Show lists
      $(this).children('ul').show()
      $(this).parents('li').children('ul').show()

      // Update toggles
      $(this).children('.page-tree__toggle').addClass('page-tree__toggle--active')
      $(this).parents('li').children('.page-tree__toggle').addClass('page-tree__toggle--active')
    })
  }

  addListeners () {
    // Custom scrollbar
    this.sidebar = document.getElementById('space-toc')
    Ps.initialize(this.sidebar)

    // Listen for page tree toggle events
    $('.page-tree').on('click.spacesidebar', '.page-tree__toggle', this.onTreeToggleClick.bind(this))
  }

  removeListeners () {
    Ps.destroy(this.sidebar)
    $('.page-tree').off('click.spacesidebar', '.page-tree__toggle')
  }

  onTreeToggleClick (e) {
    // Toggle ul
    $(e.currentTarget).parent('li').children('ul').toggle()

    // Toggle class
    $(e.currentTarget).toggleClass('page-tree__toggle--active')
  }

  destroy () {
    this.removeListeners()
  }
}

export default SpaceSidebar
