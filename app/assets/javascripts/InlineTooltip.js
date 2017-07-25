import InlineControl from './InlineControl'
import Quill from 'quill'
import $ from 'jquery'

class InlineTooltip extends InlineControl {
  constructor (quill, options) {
    super(quill, options)

    // Reference to the editor
    this.$root = $(this.quill.root)

    // References to elements that will be created by this module
    this.$tooltip = null
    this.$tooltipInner = null
    this.$tooltipControls = null
    this.$tooltipArrow = null

    // Render elements
    this.render()

    // Add event listeners
    this.addListeners()
  }

  addListeners () {
    super.addListeners()

    this.$tooltip.on('click.inlinetooltip', 'button', this.onControlClick.bind(this))
    this.quill.on(Quill.events.EDITOR_CHANGE, this.onEditorChange.bind(this))
    this.$root.on('click.inlinetooltip', this.onEditorClick.bind(this))
  }

  removeListeners () {
    super.removeListeners()

    this.$tooltip.off('click.inlinetooltip', 'button')
    this.quill.off(Quill.events.EDITOR_CHANGE, this.onEditorChange)
    this.$root.off('click.inlinetooltip')
  }

  render () {
    super.render()

    // Create tooltip
    this.$tooltip = $('<div>', {class: 'ql-inline-tooltip'}) // Will have fixed dimensions that can be used for measuring
    this.$tooltipInner = $('<div>', {class: 'ql-inline-tooltip__inner'}) // Can be animated and scaled
    this.$tooltipControls = $('<div>', {class: 'ql-inline-tooltip__controls'}) // The container for tooltip controls
    this.$tooltipArrow = $('<div>', {class: 'ql-inline-tooltip__arrow'}) // The tooltip arrow

    this.$tooltip.append( this.$tooltipInner  )
    this.$tooltipInner.append( this.$tooltipControls  )
    this.$tooltipInner.append( this.$tooltipArrow  )

    // Add tooltip in the quill editor container
    this.quill.addContainer( this.$tooltip.get(0) )

    // Add controls
    this.addControls(this.$tooltipControls, this.options, 'ql-inline-tooltip__')
  }

  updateControls () {
    // Get all formats for the selected range
    const range = this.quill.getSelection()
    const formats = (range === null) ? {} : this.quill.getFormat(range)
    let controlFormat = null
    let controlValue = null

    // Update active state for all controls
    this.$controls.forEach( (control) => {
      controlFormat = control.data('format')
      controlValue = control.data('value')

      // Check if the range has the control's format
      if(formats.hasOwnProperty(controlFormat) && formats[controlFormat] === controlValue) {
        control.addClass('ql-inline-tooltip__active')
      } else {
        control.removeClass('ql-inline-tooltip__active')
      }
    })

    // Show tooltip if range is a non-empty row
    if(this.isRangeEmpty(range)) {
      this.hideTooltip()
    } else {
      const bounds = this.quill.getBounds(range)
      this.showTooltip(bounds)
    }
  }

  showTooltip (bounds) {
    let newTop = bounds.top - this.$tooltip.outerHeight() - 3
    let newLeft = bounds.left + bounds.width/2 - this.$tooltip.outerWidth()/2
    const minLeft = - Math.abs( $(this.quill.container).offset().left ) + 12
    const maxLeft = $(window).width() - $(this.quill.container).offset().left - this.$tooltip.outerWidth() - 12
    if(newLeft > maxLeft) newLeft = maxLeft
    if(newLeft < minLeft) newLeft = minLeft

    // Round off values to avoid rendering issues
    newTop = Math.round(newTop)
    newLeft = Math.round(newLeft)

    // Position tooltip
    this.$tooltip.css({
      left: newLeft,
      top: newTop
    })

    // The arrow is positioned within the tooltip
    // The container position may have been adjusted to fit within the viewport
    // We calculate the diference between the centers to make sure that the arrow is always centered in the range
    const tooltipCenter = newLeft + this.$tooltip.outerWidth()/2
    const rangeCenter = bounds.left + bounds.width/2
    const difference = rangeCenter - tooltipCenter

    // - arrowWidth/2 is made with css instead as we could be measuring a scaled arrow here
    let newArrowLeft = this.$tooltip.outerWidth()/2 + difference

    // Round off values to avoid rendering issues
    newArrowLeft = Math.round(newArrowLeft)

    // Position arrow
    this.$tooltipArrow.css({
      left: newArrowLeft
    })

    // Show tooltip
    this.$tooltip.addClass('ql-inline-tooltip--visible')
  }

  hideTooltip () {
    // Hide tooltip
    this.$tooltip.removeClass('ql-inline-tooltip--visible')
  }

  isRangeEmpty(range) {
    if(range === null || range.length === 0 || this.quill.getText(range.index, range.length) === "\n") {
      return true
    } else {
      return false
    }
  }

  onControlClick (e) {
    e.preventDefault()

    // Get format and value from button
    const $control = $(e.currentTarget)
    const format = $control.data('format')
    const value = (format === 'link') ? prompt('Enter link') : $control.data('value')

    // Remove formatting if the control is already active
    if($control.hasClass('ql-inline-tooltip__active')) {
      this.quill.format(format, false, Quill.sources.USER)

    // Otherwise add formatting
    } else {
      this.quill.format(format, value, Quill.sources.USER)
    }

    // Update controls manually as we don't get an editor change event
    this.updateControls()
  }

  onEditorChange (e) {
    // Ignore the event if it's not a selection change
    if (e !== Quill.events.SELECTION_CHANGE) return

    // Update based on the new selection
    this.updateControls()
  }

  onEditorClick (e) {
    // Find the blot that received the click
    const clickTarget = Quill.find(e.target)

    // Check if the blot is a link or within a link, e.g. a > strong
    const $link = $(clickTarget.domNode).closest('a')

    // Check if the user clicked on a link
    if( $link.length > 0 ) {

      // Get url
      const href = $link.attr('href')

      // Redirect to the url
      window.location.href = href
    }
  }

  destroy () {
    super.destroy()

    this.$tooltip.remove()
    this.$tooltipInner.remove()
    this.$tooltipControls.remove()
    this.$tooltipArrow.remove()
  }
}

// Register as a quill module
Quill.register('modules/inlineTooltip', InlineTooltip)

export default InlineTooltip
