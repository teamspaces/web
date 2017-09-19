import $ from 'jquery'

class Overlays {
  constructor () {
    // Add event listeners when the dom is ready
    $(this.addListeners.bind(this))
  }

  addListeners () {
    // Adds event listeners with a .overlays namespace
    $('.overlay__toggle').on('click.overlays', this.onToggleClick.bind(this))
    $(document).on('click.overlays', this.onDocumentClick.bind(this))
    $(document).on('keyup.overlays', this.onDocumentKeyUp.bind(this))
  }

  removeListeners () {
    // Removes event listeners with the .overlays namespace
    $('.overlay__toggle').off('.overlays')
    $(document).off('.overlays')
  }

  onToggleClick (e) {
    e.preventDefault()

    const $toggle = $(e.currentTarget)
    const $overlay = $( $toggle.attr('href') )

    this.hideOtherOverlays($overlay)
    this.toggleOverlay($overlay)
  }

  onDocumentClick (e) {
    // Hide all overlays if the click was not within a overlay
    if(!$(e.target).closest('.overlay, .overlay__toggle').length)
      this.hideAllOverlays()
  }

  onDocumentKeyUp (e) {
    // Pressing escape hides all overlays
    if(e.keyCode === 27)
      this.hideAllOverlays()
  }

  toggleOverlay(overlay) {
    overlay.toggleClass('overlay--visible')
    this.updateScroll()
  }

  hideOtherOverlays (overlay) {
    const visible = $('.overlay--visible')

    // Hide any visible overlays (but not if it's the new one or the new overlay is nested within it)
    visible.each(function(i, el) {
      if(!$(el).has(overlay).length && !$(el).is(overlay))
        $(el).removeClass('overlay--visible')
    })
  }

  hideAllOverlays () {
    $('.overlay').removeClass('overlay--visible')
    this.updateScroll()
  }

  updateScroll () {
    // Disable body scrolling on smaller viewports when an overlay is visible
    if($('.overlay--visible').length) {
      $('body').addClass('body--mobile-no-scroll')
    } else {
      $('body').removeClass('body--mobile-no-scroll')
    }
  }

  destroy () {
    this.hideAllOverlays()
    this.removeListeners()
  }
}

export default Overlays
