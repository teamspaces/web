import $ from 'jquery'

class Tabs {
  constructor () {
    // Add event listeners when the dom is ready
    $(this.onDomIsReady.bind(this))
  }

  onDomIsReady () {
    // Loop through all collections of tabs and display the initial tab
    $('.tabs').each( function() {
      const links = $(this).find('.tabs__link')
      const tabs = $(this).find('.tabs__tab')
      const active = $(this).find('.tabs__link--active')
      const activeIndex = links.index( active )
      const activeTab = $( tabs.get( activeIndex ) )

      activeTab.addClass('tabs__tab--active')
    })

    // Add listeners
    this.addListeners()
  }

  addListeners () {
    $('.tabs__link').on('click.tabs', this.onLinkClick.bind(this))
  }

  removeListeners () {
    $('.tabs__link').off('.tabs')
  }

  onLinkClick (e) {
    e.preventDefault()

    const link = $(e.currentTarget)
    const links = link.closest('.tabs').find('.tabs__link')
    const tabs = link.closest('.tabs').find('.tabs__tab')
    const index = links.index( link )

    // Remove active class from links
    links.removeClass('tabs__link--active')

    // Add active class to new link
    link.addClass('tabs__link--active')

    // Hide tabs
    tabs.removeClass('tabs__tab--active')

    // Show new tab
    $( tabs.get(index) ).addClass('tabs__tab--active')
  }

  destroy () {
    this.removeListeners()
  }
}

export default Tabs
