import $ from 'jquery'

class Overflows {
  constructor () {
    // Add event listeners when the dom is ready
    $(this.addListeners.bind(this))
  }

  addListeners () {
    // Adds event listeners with a .overlays namespace
    $('.overflow__toggle').on('click.overflows', this.onToggleClick.bind(this))
    $(document).on('click.overflows', this.onDocumentClick.bind(this))
    $(document).on('keyup.overflows', this.onDocumentKeyUp.bind(this))
  }

  removeListeners () {
    // Removes event listeners with the .overflows namespace
    $('.overflow__toggle').off('.overflows')
    $(document).off('.overflows')
  }

  onToggleClick (e) {
    e.preventDefault()

    const $toggle = $(e.currentTarget)
    const $overflow = $toggle.parent('.overflow')

    this.hideOtherOverflows($overflow)
    this.toggleOverflow($overflow)
  }

  onDocumentClick (e) {
    // Hide all overlays if the click was not within a overflow
    if(!$(e.target).closest('.overflow__toggle, .overflow__content').length)
      this.hideAllOverflows()
  }

  onDocumentKeyUp (e) {
    // Pressing escape hides all overflows
    if(e.keyCode === 27)
      this.hideAllOverflows()
  }

  toggleOverflow(overflow) {
    overflow.toggleClass('overflow--open')
  }

  hideOtherOverflows (overflow) {
    const visible = $('.overflow--open')

    // Hide any visible overlow (but not if it's the new one or the new overflow is nested within it)
    visible.each(function(i, el) {
      if(!$(el).has(overflow).length && !$(el).is(overflow))
        $(el).removeClass('overflow--open')
    })
  }

  hideAllOverflows () {
    $('.overflow').removeClass('overflow--open')
  }

  destroy () {
    this.hideAllOverflows()
    this.removeListeners()
  }
}

export default Overflows
