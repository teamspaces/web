import $ from 'jquery'

class Dropdowns {
  constructor () {
    // Add event listeners when the dom is ready
    $(this.addListeners.bind(this))
  }

  addListeners () {
    // Adds event listeners with a .dropdowns namespace
    $('.dropdown__toggle').on('click.dropdowns', this.onToggleClick.bind(this))
    $(document).on('click.dropdowns', this.onDocumentClick.bind(this))
    $(document).on('keyup.dropdowns', this.onDocumentKeyUp.bind(this))
  }

  removeListeners () {
    // Removes event listeners with the .dropdowns namespace
    $('.dropdown__toggle').off('.dropdowns')
    $(document).off('.dropdowns')
  }

  onToggleClick (e) {
    e.preventDefault()

    const toggle = $(e.currentTarget)
    const parent = toggle.parent()
    const content = parent.children('.dropdown__content')

    this.hideOtherDropdowns(content)
    content.toggleClass('dropdown__content--visible')
  }

  onDocumentClick (e) {
    // Hide all dropdowns if the click was not within a dropdown
    if(!$(e.target).closest('.dropdown').length)
      this.hideAllDropdowns()
  }

  onDocumentKeyUp (e) {
    // Pressing escape hides all dropdowns
    if(e.keyCode === 27)
      this.hideAllDropdowns()
  }

  hideOtherDropdowns (dropdownContent) {
    const visible = $('.dropdown__content--visible')

    // Hide any visible dropdowns (but not if it's the new one or the new dropdown is nested within it)
    visible.each(function(i, el) {
      if(!$(el).has(dropdownContent).length && !$(el).is(dropdownContent))
        $(el).removeClass('dropdown__content--visible')
    })
  }

  hideAllDropdowns () {
    $('.dropdown__content').removeClass('dropdown__content--visible')
  }

  destroy () {
    this.hideAllDropdowns()
    this.removeListeners()
  }
}

export default Dropdowns
