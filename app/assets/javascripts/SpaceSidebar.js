import $ from 'jquery'
import Ps from 'perfect-scrollbar'
import throttle from 'lodash/throttle'
import PageHierarchy from './PageHierarchy'
import PageTree from './PageTree'

class SpaceSidebar {
  constructor (options) {
    if(!options || !options.pageHierarchySettings || !options.pageTreeContainer) {
      throw new Error('SpaceSidebar constructor requires options.pageHierarchySettings and options.pageTreeContainer')
    }

    this.pageHierarchySettings = options.pageHierarchySettings
    this.pageTreeContainer = options.pageTreeContainer
    this.pageHierarchy = null

    // Wait until the dom has loaded
    $(this.onDomLoaded.bind(this))
  }

  addListeners () {
    // Custom scrollbar
    Ps.initialize( $('#space-toc').get(0) )

    // Page tree toggle events
    this.pageTreeContainer.on('click.spacesidebar', '.page-tree__toggle', this.onTreeToggleClick.bind(this))

    // Window resize events
    $(window).on('resize.spacesidebar', throttle(this.onWindowResize.bind(this), 100))

    // Space navigation toggle on smaller viewports
    $('.mobile-space-navigation__toggle').on('click.spacesidebar', this.onMobileNavigationToggleClick.bind(this))

    // Update sidebar when the page name is updated
    $('#title-input').on('input.spacesidebar', this.onTitleInput.bind(this))
  }

  removeListeners () {
    Ps.destroy( $('#space-toc').get(0) )
    this.pageTreeContainer.off('click.spacesidebar', '.page-tree__toggle')
    $(window).off('resize.spacesidebar')
    $('.mobile-space-navigation__toggle').on('click.spacesidebar')
    $('#title-input').on('input.spacesidebar')
  }

  initTree () {
    // Create a page hierarchy
    this.pageHierarchy = new PageHierarchy(this.pageHierarchySettings)

    // Create a sortable page tree
    new PageTree({
      container: this.pageTreeContainer,
      onChange: this.onPageTreeChange.bind(this)
    })

    // Update page tree toggles state based on the active page
    this.pageTreeContainer.find('.page-tree__active').each(function() {
      // Show lists
      $(this).children('ul').show()
      $(this).parents('li').children('ul').show()

      // Update toggles
      $(this).children('.page-tree__toggle').addClass('page-tree__toggle--active')
      $(this).parents('li').children('.page-tree__toggle').addClass('page-tree__toggle--active')
    })
  }

  updateActionsPosition () {
    // Get the available height for the sidebar container
    const viewportHeight = $(window).height() - parseInt( $('.space-toc').css('top') )

    // Measure the content height of the sidebar
    let innerHeight = $('.space-toc__inner').get(0).scrollHeight

    // Use fixed position for the actions if the sidebar content is higher than than the viewport
    if(innerHeight > viewportHeight) {
      $('.space-toc').addClass('space-toc--fixed-actions')
    } else {
      $('.space-toc').removeClass('space-toc--fixed-actions')
    }
  }

  onDomLoaded () {
    this.initTree()
    this.updateActionsPosition()
    this.addListeners()
  }

  onTreeToggleClick (e) {
    // Toggle ul
    $(e.currentTarget).parent('li').children('ul').toggle()

    // Toggle class
    $(e.currentTarget).toggleClass('page-tree__toggle--active')

    // Update actions positions based on the new height
    this.updateActionsPosition()
  }

  onWindowResize (e) {
    this.updateActionsPosition()
  }

  onMobileNavigationToggleClick (e) {
    e.preventDefault()
    $('.mobile-space-navigation__toggle').toggleClass('mobile-space-navigation__toggle--open')
    $('.mobile-space-navigation__content').stop().fadeToggle()
    $('body').toggleClass('body--mobile-no-scroll')
  }

  onTitleInput (e) {
    const val = $('#title-input').text()

    $('.page-tree__active > .page-tree__page-inner .page-tree__page-link').html(val)
  }

  onPageTreeChange (hierarchy) {
    // TODO Make sure that toggles open/closed states are correct when reordering pages
    // Remove all page toggles
    $('.page-tree__toggle').remove()

    // Add new page toggles
    this.pageTreeContainer.find('li').each(function() {
      const ul = $(this).children('ul')
      let toggleClass = 'page-tree__toggle'

      if(ul.length > 0) {
        if(ul.is(':visible')) {
          toggleClass += ' page-tree__toggle--active'
        }

        $(this).append('<span class="' + toggleClass + '"></span>')
      }
    })

    const promise = this.pageHierarchy.update({ page_hierarchy: hierarchy })

    promise.then( (response) => {
      // console.log('Successfully updated page hierarchy')
    })

    // Update actions position
    this.updateActionsPosition()
  }

  destroy () {
    this.removeListeners()
  }
}

export default SpaceSidebar
