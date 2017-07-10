import InlineControl from './InlineControl'
import Quill from 'quill'
import Break from 'quill/blots/break'
import $ from 'jquery'

class InlineRow extends InlineControl {
  constructor (quill, options) {
    super(quill, options)

    // References to elements that will be created by this module
    this.$rowControls = null
    this.$rowToggle = null

    // Current mouse position
    this.clientX = 0
    this.clientY = 0
    this.pageX = 0
    this.pageY = 0

    // State for row controls
    this.isRowControlsOpen = false
    this.rowControlsTarget = null
    this.rowControlsTargetIndex = 1

    // Render elements
    this.render()

    // Add event listeners
    this.addListeners()
  }

  addListeners () {
    super.addListeners()

    this.$rowControls.on('click.inlinerow', 'button', this.onControlClick.bind(this))
    this.$rowToggle.on('click.inlinerow', this.onRowToggleClick.bind(this))
    $(document).on('mousemove.inlinerow', this.onMouseMove.bind(this))
    this.quill.on(Quill.events.EDITOR_CHANGE, this.onEditorChange.bind(this))
  }

  removeListeners () {
    super.removeListeners()

    this.$rowControls.off('click.inlinerow', 'button')
    this.$rowToggle.off('click.inlinerow')
    $(document).off('mousemove.inlinerow')
    this.quill.off(Quill.events.EDITOR_CHANGE, this.onEditorChange)
  }

  render () {
    super.render()

    // Create row controls and toggle
    this.$rowControls = $('<div>', {class: 'ql-inline-row__controls'})
    this.$rowToggle = $('<div>', {class: 'ql-inline-row__toggle'})

    // Add new elements in the quill editor container
    this.quill.addContainer( this.$rowControls.get(0) )
    this.quill.addContainer( this.$rowToggle.get(0) )

    // Add controls
    this.addControls(this.$rowControls, this.options, 'ql-inline-row__')
  }

  positionToggle () {
    // Only update when the controls are closed
    if(!this.isRowControlsOpen) {
      let bounds = null

      // We try to find bounds based on the mouse position first
      // We'll look for a block (not inline) element in the editor with the same y position
      // We move x to the right side of the document to avoid the row controls that can be animating above the element
      const $editor = $(this.quill.container).find('.ql-editor')
      const mouseX = $editor.offset().left + parseInt($editor.css('border-left-width')) + parseInt($editor.css('margin-left')) + parseInt($editor.css('padding-left')) + $editor.width() - 10 // Subtracting 10 pixels extra here just to be safe
      const mouseY = this.clientY

      // Find an element under the new point
      const element = document.elementFromPoint(mouseX, mouseY)

      // Find the closest block level parent
      const $block = $(element).closest('h1, h2, h3, h4, ul, ol, p, pre, table, img')

      // Double check that the block is within the editor
      if( $block.closest('.ql-editor').length > 0 ) {

        // Store a reference to the new target
        this.rowControlsTarget = $block.get(0)

        // Get the bounds
        bounds = {
          top: $block.position().top,
          left: $block.position().left,
          width: $block.outerWidth(),
          height: $block.outerHeight(),
        }
      }

      // Show and position based on the mouse position if it's over the page
      if(bounds && this.isMouseOverLeftHalfOfPage()) {
        // Add the element's top margin to the position
        bounds.top = bounds.top + parseInt($block.css('margin-top'))

        this.showRowToggle(bounds)

      // Show and position based on the focused row if the row is's empty
      } else if (this.quill.hasFocus() && this.isOnStartOfNewLine()) {

        // Get the bounds of the row
        const range = this.quill.getSelection()
        bounds = this.quill.getBounds(range)

        this.showRowToggle(bounds)

      // Hide if the mouse is not over the page and the focus is not on an empty row
      } else {
        this.hideRowToggle()
      }
    }
  }

  showRowToggle (bounds) {
    // Positon toggle
    this.$rowToggle.css({
      top: bounds.top
    })

    // Show the row toggle
    this.$rowToggle.addClass('ql-inline-row__toggle--visible')
  }

  hideRowToggle () {
    this.$rowToggle.removeClass('ql-inline-row__toggle--visible')
  }

  toggleRowControls () {
    // Close the controls if they're open
    if(this.isRowControlsOpen) {
      this.hideRowControls()

    // Otherwise show the controls and push the content down by inserting and empty row
    } else {
      this.showRowControls()
    }

    this.positionToggle()
  }

  showRowControls () {
    if(this.isRowControlsOpen) return

    // Update state
    this.isRowControlsOpen = true

    // Position controls
    this.$rowControls.css({
      top: this.$rowToggle.position().top
    })

    // Find an index where the new row should be inserted
    if(this.rowControlsTarget) {
      // Search for the dom node's corresponing blot
      const blot = Quill.find(this.rowControlsTarget)

      if(blot) {
        // Get the index for the start of the blot
        this.rowControlsTargetIndex = this.quill.getIndex(blot)
      } else {
        this.rowControlsTargetIndex = 1
      }
    } else {
      this.rowControlsTargetIndex = 1
    }

    // Insert a new row unless it's already empty
    let [leaf, offset] = this.quill.getLeaf(this.rowControlsTargetIndex)

    // if(leaf && leaf.constructor.name !== 'Break') {
      this.quill.insertText(this.rowControlsTargetIndex, '\n', false, Quill.sources.USER)
      this.quill.removeFormat(this.rowControlsTargetIndex, 0, Quill.sources.USER)
    // }

    // Show the controls
    this.$rowControls.addClass('ql-inline-row__controls--open')
    this.$rowToggle.addClass('ql-inline-row__toggle--open')
  }

  hideRowControls () {
    if(!this.isRowControlsOpen) return

    // Update state
    this.isRowControlsOpen = false

    // Remove the empty row if we earlier if we closed the controls without adding something
    let [leaf, offset] = this.quill.getLeaf(this.rowControlsTargetIndex)

    if( leaf !== null && leaf.constructor.name === 'Break' && leaf.parent.constructor.name === 'Block') {
      this.quill.deleteText(this.rowControlsTargetIndex, 1, Quill.sources.USER)
    }

    // Hide the controls
    this.$rowControls.removeClass('ql-inline-row__controls--open')
    this.$rowToggle.removeClass('ql-inline-row__toggle--open')
  }

  isMouseOverLeftHalfOfPage () {
    const containerOffset = $(this.quill.container).offset()

    const minX = containerOffset.left
    const maxX = containerOffset.left + 300
    const minY = containerOffset.top
    const maxY = containerOffset.top + $(this.quill.container).outerHeight()

    if(this.pageX >= minX && this.pageX <= maxX && this.pageY >= minY && this.pageY <= maxY) {
      return true
    } else {
      return false
    }
  }

  isOnStartOfNewLine () {
    let isOnNewLine = false
    const range = this.quill.getSelection()

    if(range !== null && range.length === 0) {

      // Check if the current range is on a new empty line
      // TODO Is there a better way to check for empty new lines? (not empty headlines etc.)
      let [leaf, offset] = this.quill.getLeaf(range.index)

      if( leaf !== null && leaf.constructor.name === 'Break' && leaf.parent.constructor.name === 'Block') {
        isOnNewLine = true
      } else {
        isOnNewLine = false
      }
    } else {
      isOnNewLine = false
    }

    return isOnNewLine
  }

  onMouseMove (e) {
    this.clientX = e.clientX
    this.clientY = e.clientY
    this.pageX = e.pageX
    this.pageY = e.pageY

    this.positionToggle()
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

    this.quill.formatLine(this.rowControlsTargetIndex, 1, format, value, Quill.sources.USER)
    this.quill.setSelection(this.rowControlsTargetIndex, 0)
  }

  onEditorChange (e) {
    // Ignore the event if it's not a selection change
    if (e !== Quill.events.SELECTION_CHANGE) return

    // Hide the row controls when the selection changed
    this.hideRowControls()

    // Update positions
    this.positionToggle()
  }

  destroy () {
    super.destroy()

    this.$rowControls.remove()
    this.$rowToggle.remove()
    this.$controls.remove()
    this.rowControlsTarget = null
  }
}

// Register as a quill module
Quill.register('modules/inlineRow', InlineRow)

export default InlineRow
