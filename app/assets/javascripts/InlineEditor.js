import Quill from 'quill'
import Break from 'quill/blots/block'

// TODO Show prompt for link urls

class InlineEditor {
  constructor(quill, options) {
    this.quill = quill
    this.tooltipControls = options.tooltipControls
    this.rowControls = options.rowControls
    this.$tooltipContainer = null
    this.$tooltipArrow = null
    this.$rowContainer = null
    this.$rowToggle = null
    this.controls = []

    // Render controls
    this.render()

    // Add event listeners
    this.addListeners()
  }

  addListeners () {
    this.$tooltipContainer.on('click.inlineeditor', 'button', this.onControlClick.bind(this))
    this.$rowContainer.on('click.inlineeditor', 'button', this.onControlClick.bind(this))
    this.$rowToggle.on('click.inlineeditor', this.onRowToggleClick.bind(this))
    this.quill.on(Quill.events.EDITOR_CHANGE, this.onEditorChange.bind(this))
  }

  removeListeners () {
    this.$tooltipContainer.off('click.inlineeditor', 'button')
    this.$rowContainer.off('click.inlineeditor', 'button')
    this.$rowToggle.off('click.inlineeditor')
    this.quill.off(Quill.events.EDITOR_CHANGE, this.onEditorChange)
  }

  render () {
    // Create tooltip
    this.$tooltipContainer = $('<div>', {id: 'ql-inline-editor__tooltip'})
    this.$tooltipArrow = $('<div>', {id: 'ql-inline-editor__tooltip-arrow'})
    this.$tooltipContainer.append( this.$tooltipArrow  )

    // Add tooltip in the quill editor container
    this.quill.addContainer( this.$tooltipContainer.get(0) )

    // TODO Check for empty control options before adding controls

    // Add tooltip controls
    this.addControls(this.$tooltipContainer, this.tooltipControls)

    // Create row container
    this.$rowContainer = $('<div>', {id: 'ql-inline-editor__row'})
    this.$rowToggle = $('<div>', {id: 'ql-inline-editor__row-toggle'})
    this.$rowContainer.append( this.$rowToggle )

    // Add row in the quill editor container
    this.quill.addContainer( this.$rowContainer.get(0) )

    // Add row controls
    this.addControls(this.$rowContainer, this.rowControls)
  }

  addControls (container, controls) {
    // Ensure that the controls are grouped
    const groups = ( Array.isArray(controls[0]) ) ? controls : [controls]
    let format = null
    let value = null

    // Loop through the groups
    groups.forEach( (group, index) => {

      // Add controls for the group
      group.forEach( (control) => {

        // Add directly if it's a string
        if(typeof control === 'string') {
          format = control
          value = null
          this.addControl(container, format)

        // Extract the format and the value if it's an object
        } else {
          format = Object.keys(control)[0]
          value = control[format]
          this.addControl(container, format, value)
        }
      })

      // Add a divider after the group if there are more groups
      if(groups.length > index + 1) {
        this.addDivider(container)
      }
    })
  }

  addControl (container, format, value) {
    // Create button
    const classSuffix = (value) ? format + '-' + value : format
    const button = $('<button>', { 'class': 'ql-inline-editor__' + classSuffix })

    // Save format and value as data attributes
    button.attr('data-format', format)
    button.attr('data-value', value || true)

    // Save reference to control
    this.controls.push(button)

    // Add button in container
    container.append(button)
  }

  addDivider (container) {
    // Create divider
    const divider = $('<div>', { 'class': 'ql-inline-editor__divider' })

    // Add divider in container
    container.append(divider)
  }

  updateControls () {
    // Get formats for the current range
    const range = this.quill.getSelection()
    const formats = (range === null) ? {} : this.quill.getFormat(range)
    let controlFormat = null
    let controlValue = null

    // Toggle tooltip visibibility
    if(range === null || range.length === 0 || this.quill.getText(range.index, range.length) === "\n") {
      // Hide tooltip
      this.$tooltipContainer.removeClass('ql-inline-editor__tooltip--visible')
    } else {
      // Get bounds of current range and make sure that the new position fits within the viewport
      const rangeBounds = this.quill.getBounds(range)
      const minLeft = - Math.abs( $(this.quill.container).offset().left ) + 12
      const maxLeft = $(window).width() - $(this.quill.container).offset().left - this.$tooltipContainer.outerWidth() - 12
      let newLeft = rangeBounds.left + rangeBounds.width/2 - this.$tooltipContainer.outerWidth()/2
      if(newLeft > maxLeft) newLeft = maxLeft
      if(newLeft < minLeft) newLeft = minLeft

      // Position tooltip
      this.$tooltipContainer.css({
        left: newLeft,
        top: rangeBounds.top - this.$tooltipContainer.outerHeight() - this.$tooltipArrow.outerHeight() - 3
      })

      // The arrow is positioned within the tooltip container
      // The container may have been adjusted to fit within the viewport
      // We calculate the diference between the centers to make sure that the arrow is always centered
      const tooltipCenter = newLeft + this.$tooltipContainer.outerWidth()/2
      const rangeCenter = rangeBounds.left + rangeBounds.width/2
      const difference = rangeCenter - tooltipCenter

      // Position arrow
      this.$tooltipArrow.css({
        left: this.$tooltipContainer.outerWidth()/2 - this.$tooltipArrow.outerWidth()/2 + difference
      })

      // Show tooltip
      this.$tooltipContainer.addClass('ql-inline-editor__tooltip--visible')
    }

    // Update active state for all controls
    this.controls.forEach( (control) => {
      controlFormat = control.data('format')
      controlValue = control.data('value')

      // Check if the range has the control's format
      if(formats.hasOwnProperty(controlFormat) && formats[controlFormat] === controlValue) {
        control.addClass('ql-inline-editor__active')
      } else {
        control.removeClass('ql-inline-editor__active')
      }
    })

    // Show or hide row toggle
    if(range !== null && range.length === 0) {

      // Show the row controls if the first child is a br
      // TODO Is there a better way to check for empty new lines? (not empty headlines etc.)
      let [leaf, offset] = this.quill.getLeaf(range.index)
      let [line, offset2] = this.quill.getLine(range.index)

      if( leaf !== null && leaf.constructor.name === 'Break' && line.constructor.name === 'Block' ) {
        // Position the row controls
        let lineBounds = this.quill.getBounds(range)
        this.$rowContainer.css({
          left: lineBounds.left,
          top: lineBounds.top + lineBounds.height/2 - this.$rowContainer.outerHeight()/2
        })

        // Show the row toggle
        this.$rowContainer.addClass('ql-inline-editor__row--visible')
      } else {
        this.$rowContainer.removeClass('ql-inline-editor__row--visible')
      }
    } else {
      this.$rowContainer.removeClass('ql-inline-editor__row--visible')
    }
  }



  /**
   * Event listeners
   */
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

  onRowToggleClick (e) {
    e.preventDefault();

    // Togggle the visiblity of the row buttons
    this.$rowContainer.toggleClass('ql-inline-editor__row--open')
    this.quill.focus()
  }

  onEditorChange (e, range) {
    // Ignore the event if it's not a selection change
    if (e !== Quill.events.SELECTION_CHANGE) return

    // Update all controls based on the current range
    this.updateControls()
  }



  /**
   * Destructor
   */
  destroy () {
    this.removeListeners()

    this.quill = null
    this.tooltipControls = null
    this.$tooltipContainer = null
    this.controls = null
  }
}

// Register as a quill module
Quill.register('modules/inlineEditor', InlineEditor)

export default InlineEditor
