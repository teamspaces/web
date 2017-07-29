import Quill from 'quill'
import $ from 'jquery'

class InlineToolbar {
  constructor(quill, options) {
    this.quill = quill
    this.options = options
    this.$controls = []
  }

  addListeners () {

  }

  removeListeners () {

  }

  render () {

  }

  addControls (container, controls, classPrefix = '') {
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
          this.addControl(container, format, true, classPrefix)

        // Extract the format and the value if it's an object
        } else {
          format = Object.keys(control)[0]
          value = control[format]
          this.addControl(container, format, value, classPrefix)
        }
      })

      // Add a divider after the group if there are more groups
      if(groups.length > index + 1) {
        this.addDivider(container, classPrefix)
      }
    })
  }

  addControl (container, format, value, classPrefix = '') {
    // Create button
    const classSuffix = (value !== true) ? format + '-' + value : format
    const button = $('<button>', { 'class': classPrefix + classSuffix })

    // Save format and value as data attributes
    button.attr('data-format', format)
    button.attr('data-value', value)

    // Save reference to control
    this.$controls.push(button)

    // Add button in container
    container.append(button)
  }

  addDivider (container, classPrefix = '') {
    // Create divider
    const divider = $('<div>', { 'class': classPrefix + 'divider' })

    // Add divider in container
    container.append(divider)
  }

  destroy () {
    this.removeListeners()
    this.quill = null
    this.options = null
  }
}

export default InlineToolbar
