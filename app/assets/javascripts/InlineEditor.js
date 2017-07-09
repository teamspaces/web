import Quill from 'quill'

// TODO Show prompt for link urls

class InlineEditor {
  constructor(quill, options) {
    this.quill = quill
    this.tooltipControls = options.tooltipControls
    this.$tooltipContainer = null
    this.$rowContainer = null
    this.controls = []

    // Render controls
    this.render()

    // Add event listeners
    this.addListeners()
  }

  addListeners () {
    this.$tooltipContainer.on('click.inlineeditor', 'button', this.onControlClick.bind(this))
    this.quill.on(Quill.events.EDITOR_CHANGE, this.onEditorChange.bind(this))
  }

  removeListeners () {
    this.$tooltipContainer.off('click.inlineeditor', 'button')
    this.quill.off(Quill.events.EDITOR_CHANGE, this.onEditorChange)
  }

  render () {
    // Create tooltip
    this.$tooltipContainer = $('<div>', {id: 'ql-inline-editor__tooltip'})
    this.$tooltipContainer.append( $('<div>', {id: 'ql-inline-editor__tooltip-arrow'}) )

    // Add tooltip in the quill editor container
    this.quill.addContainer( this.$tooltipContainer.get(0) )

    // TODO Check for empty control options before adding controls

    // Add tooltip controls
    this.addControls(this.$tooltipContainer, this.tooltipControls)
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
      // Get bounds of current range
      const rangeBounds = this.quill.getBounds(range)

      // Position tooltip
      this.$tooltipContainer.css({
        left: rangeBounds.left + rangeBounds.width/2 - this.$tooltipContainer.outerWidth()/2,
        top: rangeBounds.top - this.$tooltipContainer.outerHeight()
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
