import Quill from 'quill'
import Break from 'quill/blots/block'
import Header from 'quill/formats/header';

class InlineEditor {
  constructor(quill, options) {
    // Store options
    // this.quill = quill
    // this.tooltipOptions = options.tooltipControls
    // this.rowOptions = options.rowControls

    // // References to elements that will be created by this module
    // this.$tooltip = null
    // this.$tooltipInner = null
    // this.$tooltipControls = null
    // this.$tooltipArrow = null
    // this.$rowControls = null
    // this.$rowToggle = null
    // this.$controls = []

    // // Current mouse position
    // this.clientX = 0
    // this.clientY = 0
    // this.pageX = 0
    // this.pageY = 0
    //
    // //
    // this.isRowControlsOpen = false
    // this.rowControlsTarget = false
    //
    // // Render elements
    // this.render()
    //
    // // Add event listeners
    // this.addListeners()
  }

  addListeners () {
    // this.$tooltip.on('click.inlineeditor', 'button', this.onControlClick.bind(this))
    // this.$rowControls.on('click.inlineeditor', 'button', this.onControlClick.bind(this))
    // this.$rowToggle.on('click.inlineeditor', this.onRowToggleClick.bind(this))
    // $(document).on('mousemove.inlineeditor', this.onMouseMove.bind(this))
    // this.quill.on(Quill.events.EDITOR_CHANGE, this.onEditorChange.bind(this))
  }

  removeListeners () {
    // this.$tooltip.off('click.inlineeditor', 'button')
    // this.$rowControls.off('click.inlineeditor', 'button')
    // this.$rowToggle.off('click.inlineeditor')
    // $(document).off('mousemove.inlineeditor')
    // this.quill.off(Quill.events.EDITOR_CHANGE, this.onEditorChange)
  }

  render () {
    // // Create tooltip
    // this.$tooltip = $('<div>', {id: 'ql-inline-editor__tooltip'}) // Will have fixed dimensions that can be used for measuring
    // this.$tooltipInner = $('<div>', {class: 'ql-inline-editor__tooltip-inner'}) // Can be animated and scaled
    // this.$tooltipControls = $('<div>', {class: 'ql-inline-editor__tooltip-controls'}) // The container for tooltip controls
    // this.$tooltipArrow = $('<div>', {class: 'ql-inline-editor__tooltip-arrow'}) // The tooltip arrow
    //
    // this.$tooltip.append( this.$tooltipInner  )
    // this.$tooltipInner.append( this.$tooltipControls  )
    // this.$tooltipInner.append( this.$tooltipArrow  )
    //
    // // Add tooltip in the quill editor container
    // this.quill.addContainer( this.$tooltip.get(0) )
    //
    // // Create tooltip controls
    // this.addControls(this.$tooltipControls, this.tooltipOptions)

    // // Create row controls and toggle
    // this.$rowControls = $('<div>', {id: 'ql-inline-editor__row-controls'})
    // this.$rowToggle = $('<div>', {id: 'ql-inline-editor__row-toggle'})
    //
    // // Add row in the quill editor container
    // this.quill.addContainer( this.$rowControls.get(0) )
    // this.quill.addContainer( this.$rowToggle.get(0) )
    //
    // // Add row controls
    // this.addControls(this.$rowControls, this.rowOptions)
  }

  // addControls (container, controls) {
  //   // Ensure that the controls are grouped
  //   const groups = ( Array.isArray(controls[0]) ) ? controls : [controls]
  //   let format = null
  //   let value = null
  //
  //   // Loop through the groups
  //   groups.forEach( (group, index) => {
  //
  //     // Add controls for the group
  //     group.forEach( (control) => {
  //
  //       // Add directly if it's a string
  //       if(typeof control === 'string') {
  //         format = control
  //         value = null
  //         this.addControl(container, format)
  //
  //       // Extract the format and the value if it's an object
  //       } else {
  //         format = Object.keys(control)[0]
  //         value = control[format]
  //         this.addControl(container, format, value)
  //       }
  //     })
  //
  //     // Add a divider after the group if there are more groups
  //     if(groups.length > index + 1) {
  //       this.addDivider(container)
  //     }
  //   })
  // }

  // addControl (container, format, value) {
  //   // Create button
  //   const classSuffix = (value) ? format + '-' + value : format
  //   const button = $('<button>', { 'class': 'ql-inline-editor__' + classSuffix })
  //
  //   // Save format and value as data attributes
  //   button.attr('data-format', format)
  //   button.attr('data-value', value || true)
  //
  //   // Save reference to control
  //   this.$controls.push(button)
  //
  //   // Add button in container
  //   container.append(button)
  // }

  // addDivider (container) {
  //   // Create divider
  //   const divider = $('<div>', { 'class': 'ql-inline-editor__divider' })
  //
  //   // Add divider in container
  //   container.append(divider)
  // }

  updateControls () {
    // this.updateTooltip()
    // this.updateRowToggle()

    // // Get all formats for the selected range
    // const range = this.quill.getSelection()
    // const formats = (range === null) ? {} : this.quill.getFormat(range)
    // let controlFormat = null
    // let controlValue = null
    //
    // // Update active state for all controls
    // this.$controls.forEach( (control) => {
    //   controlFormat = control.data('format')
    //   controlValue = control.data('value')
    //
    //   // Check if the range has the control's format
    //   if(formats.hasOwnProperty(controlFormat) && formats[controlFormat] === controlValue) {
    //     control.addClass('ql-inline-editor__active')
    //   } else {
    //     control.removeClass('ql-inline-editor__active')
    //   }
    // })

    // Show the row toggle if we're on new line or the cursor is over the left side
    // if(this.isOnStartOfNewLine() || this.isCursorOverLeftHalfOfPage()) {
    //   this.showRowToggle()
    // } else {
    //   this.hideRowToggle()
    // }
  }

  // isMouseOverLeftHalfOfPage () {
  //   const containerOffset = $(this.quill.container).offset()
  //
  //   const minX = containerOffset.left
  //   const maxX = containerOffset.left + 300
  //   const minY = containerOffset.top
  //   const maxY = containerOffset.top + $(this.quill.container).outerHeight()
  //
  //   if(this.pageX >= minX && this.pageX <= maxX && this.pageY >= minY && this.pageY <= maxY) {
  //     return true
  //   } else {
  //     return false
  //   }
  // }

  // isOnStartOfNewLine () {
  //   const range = this.quill.getSelection()
  //
  //   if(range !== null && range.length === 0) {
  //     // Check if the current range is a br
  //     // TODO Is there a better way to check for empty new lines? (not empty headlines etc.)
  //     let [leaf, offset] = this.quill.getLeaf(range.index)
  //     let [line, offset2] = this.quill.getLine(range.index)
  //
  //     if( leaf !== null && leaf.constructor.name === 'Break' && line.constructor.name === 'Block' ) {
  //         return true
  //     }
  //   }
  //
  //   return false
  // }

  // isOnStartOfNewLine () {
  //   const range = this.quill.getSelection()
  //
  //   // if(range !== null && range.length === 0) {
  //   //   // Check if the current range is a br
  //   //   // TODO Is there a better way to check for empty new lines? (not empty headlines etc.)
  //   //   let [leaf, offset] = this.quill.getLeaf(range.index)
  //   //   let [line, offset2] = this.quill.getLine(range.index)
  //   //
  //   //   if( leaf !== null && leaf.constructor.name === 'Break' && line.constructor.name === 'Block' ) {
  //   //       return true
  //   //   }
  //   // }
  //
  //   if(range !== null && range.length === 0) { // && this.quill.getText(range.index, range.length) === "\n" ?
  //     return true
  //   } else {
  //     return false
  //   }
  //
  //   return false
  // }

  // updateTooltip() {
  //   const range = this.quill.getSelection()
  //   const bounds = this.quill.getBounds(range)
  //
  //   // Show tooltip if range is a non-empty row
  //   if(range === null || range.length === 0 || this.quill.getText(range.index, range.length) === "\n") {
  //     this.hideTooltip()
  //   } else {
  //     this.showTooltip(bounds)
  //   }
  // }

  // updateRowToggle () {
    // // Only reposition when the controls are closed
    // if(!this.isRowControlsOpen) {
    //   let bounds = null
    //
    //   // We try to find bounds based on the mouse position first
    //   // We'll look for a block (not inline) element in the editor with the same y position
    //   // We want to show the toggle when you hover the editor's side padding as well, so we change the mouse x position
    //   const $editor = $(this.quill.container).find('.ql-editor')
    //   const mouseX = $editor.offset().left + parseInt($editor.css('border-left-width')) + parseInt($editor.css('margin-left')) + parseInt($editor.css('padding-left')) + 5 // Adding 5 pixels extra here just to be safe
    //   const mouseY = this.clientY
    //
    //   // Find an element under the new point
    //   const element = document.elementFromPoint(mouseX, mouseY)
    //
    //   // Find the closest block level parent
    //   const $block = $(element).closest('h1, h2, h3, h4, ul, ol, p, pre, table, img')
    //
    //   // Double check that the block is within the editor
    //   if( $block.closest('.ql-editor').length > 0 ) {
    //     // Store a reference to the new target
    //     this.rowControlsTarget = $block
    //
    //     // Get the bounds
    //     bounds = {
    //       top: $block.position().top,
    //       left: $block.position().left,
    //       width: $block.outerWidth(),
    //       height: $block.outerHeight(),
    //     }
    //
    //     console.log($block, bounds)
    //   }
    //
    //
    //
    //
    //   // Find the bounds based on the mouse position first
    //   // Look for a blot under the cursor in the editor
    //   // It may return the editor or something outside depending on the position of the cursor
    //         // const node = Quill.find(this.mouseTarget)
    //         //
    //         // if(node && node.constructor) {
    //         //   const name = node.constructor.name
    //         //   const formats = ["Align", "Background", "Blockquote", "Bold", "Block", "Code", "Color", "Direction", "Embed", "Font", "Header", "Image", "Indent", "Inline", "Italic", "Link", "List", "ListItem", "Script", "Size", "Strike", "SyntaxCodeBlock", "Underline", "Video"]
    //         //
    //         //   // TODO Why is not instanceof for base classes working? Checking the constructor names here instead
    //         //   if(formats.indexOf(name) >= 0) {
    //         //
    //         //     // Get the index of the start of the block
    //         //     // If we just used the first variable here we could get the index for inline styling bold and italic
    //         //     const index = this.quill.getIndex(node)
    //         //     const [line, offset] = this.quill.getLine(index)
    //         //     const lineIndex = this.quill.getIndex(line)
    //         //
    //         //     // Get bounds of index
    //         //     bounds = this.quill.getBounds(lineIndex)
    //         //   }
    //         // }
    //
    //   // Show and position based on the mouse position if it's over the page
    //   if(bounds && this.isMouseOverLeftHalfOfPage()) {
    //     this.showRowToggle(bounds)
    //
    //   // Show and position based on the focused row if it's empty
    //   } else if (this.isOnStartOfNewLine()) {
    //
    //     // Get the bounds of the row
    //     const range = this.quill.getSelection()
    //     bounds = this.quill.getBounds(range)
    //
    //     this.showRowToggle(bounds)
    //
    //   // Hide if the page is not over the page or the focus is on an empty row
    //   } else {
    //     this.hideRowToggle()
    //   }
    // }
  // }

  // showRowToggle (bounds) {
  //   this.$rowToggle.css({
  //     left: 0,
  //     top: bounds.top
  //   })
  //
  //   this.$rowControls.css({
  //     left: 0,
  //     top: bounds.top
  //   })
  //
  //   // Show the row toggle
  //   this.$rowToggle.addClass('ql-inline-editor__row-toggle--visible')
  // }
  //
  // hideRowToggle () {
  //   this.$rowToggle.removeClass('ql-inline-editor__row-toggle--visible')
  // }

  // showTooltip (bounds) {
  //   const minLeft = - Math.abs( $(this.quill.container).offset().left ) + 12
  //   const maxLeft = $(window).width() - $(this.quill.container).offset().left - this.$tooltip.outerWidth() - 12
  //   let newLeft = bounds.left + bounds.width/2 - this.$tooltip.outerWidth()/2
  //   if(newLeft > maxLeft) newLeft = maxLeft
  //   if(newLeft < minLeft) newLeft = minLeft
  //
  //   // Position tooltip
  //   this.$tooltip.css({
  //     left: newLeft,
  //     top: bounds.top - this.$tooltip.outerHeight() - 3
  //   })
  //
  //   // The arrow is positioned within the tooltip
  //   // The container position may have been adjusted to fit within the viewport
  //   // We calculate the diference between the centers to make sure that the arrow is always centered in the range
  //   const tooltipCenter = newLeft + this.$tooltip.outerWidth()/2
  //   const rangeCenter = bounds.left + bounds.width/2
  //   const difference = rangeCenter - tooltipCenter
  //
  //   // Position arrow
  //   this.$tooltipArrow.css({
  //     left: this.$tooltip.outerWidth()/2 + difference
  //     // - arrowWidth/2 is made with css instead as it can be scaled when calculated here
  //   })
  //
  //   // Show tooltip
  //   this.$tooltip.addClass('ql-inline-editor__tooltip--visible')
  // }
  //
  // hideTooltip () {
  //   // Hide tooltip
  //   this.$tooltip.removeClass('ql-inline-editor__tooltip--visible')
  // }



  /**
   * Event listeners
   */
  // onControlClick (e) {
  //   e.preventDefault()
  //
  //   // Get format and value from button
  //   const $control = $(e.currentTarget)
  //   const format = $control.data('format')
  //   const value = $control.data('value')
  //
  //   // Remove formatting if the control is already active
  //   if($control.hasClass('ql-inline-editor__active')) {
  //     this.quill.format(format, false, Quill.sources.USER)
  //
  //   // Otherwise add formatting
  //   } else {
  //     this.quill.format(format, value, Quill.sources.USER)
  //   }
  //
  //   // Update controls manually as we don't get an editor change event
  //   this.updateControls()
  // }

  // onRowToggleClick (e) {
  //   e.preventDefault();
  //
  //   // Togggle the visiblity of the row controls
  //   this.$rowControls.toggleClass('ql-inline-editor__row-controls--open')
  //   this.$rowToggle.toggleClass('ql-inline-editor__row-toggle--open')
  //
  //   // Bring focus back to the editor
  //   this.quill.focus()
  // }

  // onEditorChange (e, range) {
  //   // Ignore the event if it's not a selection change
  //   if (e !== Quill.events.SELECTION_CHANGE) return
  //
  //   // Update all controls based on the current range
  //   this.updateControls()
  // }

  // onMouseMove (e) {
  //   this.clientX = e.clientX
  //   this.clientY = e.clientY
  //   this.pageX = e.pageX
  //   this.pageY = e.pageY
  //
  //   this.updateRowToggle()
  // }



  /**
   * Destructor
   */
  destroy () {
    // this.removeListeners()

    // this.quill = null
    // this.tooltipOptions = null
    // this.rowOptions = null

    // this.$tooltip.remove()
    // this.$tooltipInner.remove()
    // this.$tooltipControls.remove()
    // this.$tooltipArrow.remove()
    // this.$rowControls.remove()
    // this.$rowToggle.remove()
    // this.$controls.remove()
  }
}

// Register as a quill module
Quill.register('modules/inlineEditor', InlineEditor)

export default InlineEditor
