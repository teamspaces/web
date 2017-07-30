import InlineToolbar from './InlineToolbar'
import Quill from 'quill'
import $ from 'jquery'
import tippy from 'tippy.js/dist/tippy'

class InlineRow extends InlineToolbar {
  constructor (quill, options) {
    super(quill, options)

    // References to elements that will be created by this module
    this.$rowControls = null
    this.$rowToggle = null
    this.tip = null

    // State for row controls
    this.isRowControlsOpen = false
    this.currentIndex = 0

    // Render elements
    this.render()

    // Add event listeners
    this.addListeners()
  }

  addListeners () {
    super.addListeners()

    this.$rowControls.on('click.inlinerow', 'button', this.onControlClick.bind(this))
    this.$rowToggle.on('click.inlinerow', this.onRowToggleClick.bind(this))
    this.quill.on(Quill.events.EDITOR_CHANGE, this.onEditorChange.bind(this))
  }

  removeListeners () {
    super.removeListeners()

    this.$rowControls.off('click.inlinerow', 'button')
    this.$rowToggle.off('click.inlinerow')
    this.quill.off(Quill.events.EDITOR_CHANGE, this.onEditorChange)
  }

  render () {
    super.render()

    // Create row controls and toggle
    this.$rowControls = $('<div>', {class: 'ql-inline-row__controls'})
    this.$rowToggle = $('<div>', {class: 'ql-inline-row__toggle', title: 'Insert'})

    // Add new elements in the quill editor container
    this.quill.addContainer( this.$rowControls.get(0) )
    this.quill.addContainer( this.$rowToggle.get(0) )

    // Add controls
    this.addControls(this.$rowControls, this.options, 'ql-inline-row__')

    // Create tooltip
    this.tip = tippy('.ql-inline-row__toggle', {
      position: 'top',
      arrow: true,
      arrowSize: 'small',
      animation: 'shift',
      delay: [100, 0],
      distance: -3,
      size: 'regular',
      theme: 'spaces',
      sticky: true,
      animateFill: false,
      zIndex: 99
    })
  }

  update () {
    // Get range for current selection
    const range = this.quill.getSelection()

    // Use previous index if the range is empty,
    // e.g. if the user clicks on the toggle which removes focus from the editor
    const index = (range !== null) ? range.index : this.currentIndex

    // Update index
    this.currentIndex = index

    // Show the toggle if the index is on a new empty line
    // and hide the controls in case they were opened on a different line
    if( this.isOnStartOfNewLine(this.currentIndex) ) {
      this.showRowToggle()
      this.hideRowControls()

    // Otherwise hide both the toggle and the controls
    } else {
      this.hideRowToggle()
      this.hideRowControls()
    }
  }

  showRowToggle () {
    // Get the bounds of the current row
    const bounds = this.quill.getBounds(this.currentIndex, 0)

    // Positon toggle
    this.$rowToggle.css({
      top: bounds.top
    })

    // Show toggle
    this.$rowToggle.addClass('ql-inline-row__toggle--visible')
  }

  hideRowToggle () {
    this.$rowToggle.removeClass('ql-inline-row__toggle--visible')
  }

  toggleRowControls () {
    // Close the controls if they're open
    if(this.isRowControlsOpen) {
      this.hideRowControls()

    // Otherwise show the controls
    } else {
      this.showRowControls()
    }
  }

  showRowControls () {
    this.isRowControlsOpen = true

    // Position controls
    this.$rowControls.css({
      top: this.$rowToggle.position().top
    })

    // Show the controls
    this.$rowControls.addClass('ql-inline-row__controls--open')
    this.$rowToggle.addClass('ql-inline-row__toggle--open')
  }

  hideRowControls () {
    this.isRowControlsOpen = false

    // Hide the controls
    this.$rowControls.removeClass('ql-inline-row__controls--open')
    this.$rowToggle.removeClass('ql-inline-row__toggle--open')
  }

  isOnStartOfNewLine (index) {
    let isOnNewLine = false

    // Check if the current range is on a new empty line
    // TODO Is there a better way to check for empty new lines? (not empty headlines etc.)
    let [leaf, offset] = this.quill.getLeaf(index)

    if( leaf !== null && leaf.constructor.name === 'Break' && leaf.parent.constructor.name === 'Block') {
      isOnNewLine = true
    } else {
      isOnNewLine = false
    }

    return isOnNewLine
  }

  onRowToggleClick (e) {
    e.preventDefault();

    this.toggleRowControls()
  }

  onControlClick (e) {
    e.preventDefault()

    // Get format and value from button
    const $control = $(e.currentTarget)
    const format = $control.data('format')
    const value = $control.data('value')

    // Save current scroll position
    const scrollTop = $(document).scrollTop()

    // Format row
    this.quill.formatLine(this.currentIndex, 1, format, value, Quill.sources.USER)
    this.quill.setSelection(this.currentIndex, 0)

    // Update scroll position to avoid jumping scroll behavior
    $(document).scrollTop(scrollTop)
  }

  onEditorChange (e) {
    // Listen for selection and text changes
    if (e === Quill.events.SELECTION_CHANGE || e === Quill.events.TEXT_CHANGE) {
      this.update()
    }
  }

  destroy () {
    super.destroy()

    this.$rowControls.remove()
    this.$rowToggle.remove()
    this.$controls.remove()
    this.tip.destroyAll()
  }
}

// Register as a quill module
Quill.register('modules/inlineRow', InlineRow)

export default InlineRow
