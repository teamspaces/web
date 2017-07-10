import InlineControl from './InlineControl'
import Quill from 'quill'
import $ from 'jquery'

class InlineTooltip extends InlineControl {
  constructor (quill, options) {
    super(quill, options)

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
  }

  removeListeners () {
    super.removeListeners()

    this.$tooltip.off('click.inlinetooltip', 'button')
  }

  render () {
    super.render()

    // Create tooltip
    this.$tooltip = $('<div>', {id: 'ql-inline-editor__tooltip'}) // Will have fixed dimensions that can be used for measuring
    this.$tooltipInner = $('<div>', {class: 'ql-inline-editor__tooltip-inner'}) // Can be animated and scaled
    this.$tooltipControls = $('<div>', {class: 'ql-inline-editor__tooltip-controls'}) // The container for tooltip controls
    this.$tooltipArrow = $('<div>', {class: 'ql-inline-editor__tooltip-arrow'}) // The tooltip arrow

    this.$tooltip.append( this.$tooltipInner  )
    this.$tooltipInner.append( this.$tooltipControls  )
    this.$tooltipInner.append( this.$tooltipArrow  )

    // Add tooltip in the quill editor container
    this.quill.addContainer( this.$tooltip.get(0) )

    // Add controls
    this.addControls(this.$tooltipControls, this.options)
  }

  updateControls () {
    super.updateControls()

    const range = this.quill.getSelection()

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
    this.$tooltip.addClass('ql-inline-editor__tooltip--visible')
  }

  hideTooltip () {
    // Hide tooltip
    this.$tooltip.removeClass('ql-inline-editor__tooltip--visible')
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
    const value = $control.data('value')

    // Remove formatting if the control is already active
    if($control.hasClass('ql-inline-editor__active')) {
      this.quill.format(format, false, Quill.sources.USER)

    // Otherwise add formatting
    } else {
      this.quill.format(format, value, Quill.sources.USER)
    }

    // Update controls manually as we don't get an editor change event
    this.updateControls()
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
