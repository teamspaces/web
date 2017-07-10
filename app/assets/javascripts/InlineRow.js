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
    this.rowControlsTargetIndex = 0

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
  }

  removeListeners () {
    super.removeListeners()

    this.$rowControls.off('click.inlinerow', 'button')
    this.$rowToggle.off('click.inlinerow')
    $(document).off('mousemove.inlinerow')
  }

  render () {
    super.render()

    // Create row controls and toggle
    this.$rowControls = $('<div>', {id: 'ql-inline-editor__row-controls'})
    this.$rowToggle = $('<div>', {id: 'ql-inline-editor__row-toggle'})

    // Add new elements in the quill editor container
    this.quill.addContainer( this.$rowControls.get(0) )
    this.quill.addContainer( this.$rowToggle.get(0) )

    // Add controls
    this.addControls(this.$rowControls, this.options)
  }

  updateControls () {
    super.updateControls()

    this.positionToggle()
  }

  positionToggle () {
    // Only update when the controls are closed
    if(!this.isRowControlsOpen) {
      let bounds = null

      // We try to find bounds based on the mouse position first
      // We'll look for a block (not inline) element in the editor with the same y position
      // We want to show the toggle when you hover the editor's side padding as well, so we change the mouse x position
      const $editor = $(this.quill.container).find('.ql-editor')
      const mouseX = $editor.offset().left + parseInt($editor.css('border-left-width')) + parseInt($editor.css('margin-left')) + parseInt($editor.css('padding-left')) + 5 // Adding 5 pixels extra here just to be safe
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
        this.showRowToggle(bounds)

      // Show and position based on the focused row if the row is's empty
      } else if (this.isOnStartOfNewLine()) {

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
      left: 0,
      top: bounds.top
    })

    // Position controls
    this.$rowControls.css({
      left: 0,
      top: bounds.top
    })

    // Show the row toggle
    this.$rowToggle.addClass('ql-inline-editor__row-toggle--visible')
  }

  hideRowToggle () {
    this.$rowToggle.removeClass('ql-inline-editor__row-toggle--visible')
  }

  toggleRowControls () {
    // Close the controls if they're open
    if(this.isRowControlsOpen) {
      this.isRowControlsOpen = false

      // Remove the empty row we created when we displayed the controls
      this.quill.deleteText(this.rowControlsTargetIndex, 1, Quill.sources.USER)

      // Hide the controls
      this.$rowControls.removeClass('ql-inline-editor__row-controls--open')

    // Otherwise show the controls and push the content down by inserting and empty row
    } else {
      this.isRowControlsOpen = true

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

      // Insert the new row
      this.quill.insertText(this.rowControlsTargetIndex, '\n', false, Quill.sources.USER)
      this.quill.removeFormat(this.rowControlsTargetIndex, 0, Quill.sources.USER)

      // Show the controls
      this.$rowControls.addClass('ql-inline-editor__row-controls--open')
    }
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
    const range = this.quill.getSelection()

    // if(range !== null && range.length === 0) {
    //   // Check if the current range is a br
    //   // TODO Is there a better way to check for empty new lines? (not empty headlines etc.)
    //   let [leaf, offset] = this.quill.getLeaf(range.index)
    //   let [line, offset2] = this.quill.getLine(range.index)
    //
    //   if( leaf !== null && leaf.constructor.name === 'Break' && line.constructor.name === 'Block' ) {
    //       return true
    //   }
    // }

    if(range !== null && range.length === 0) { // && this.quill.getText(range.index, range.length) === "\n" ?
      return true
    } else {
      return false
    }

    return false
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
