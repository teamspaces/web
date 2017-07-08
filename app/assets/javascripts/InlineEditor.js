import Quill from 'quill'

class InlineEditor {
  constructor(quill, options) {
    this.quill = quill
    this.tooltipControls = options.tooltipControls
    this.$tooltipContainer = null

    // Render controls
    this.render()

    // Add listeners
    this.addListeners()
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

    // Add button in container
    container.append(button)
  }

  addDivider (container) {
    // Create divider
    const divider = $('<div>', { 'class': 'ql-inline-editor__divider' })

    // Add divider in container
    container.append(divider)
  }

  addListeners () {

  }
}

// Register as a quill module
Quill.register('modules/inlineEditor', InlineEditor)

export default InlineEditor
