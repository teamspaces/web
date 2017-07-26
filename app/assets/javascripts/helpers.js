import Overlays from './Overlays'
import Overflows from './Overflows'
import tippy from 'tippy.js/dist/tippy'
import Clipboard from 'clipboard/dist/clipboard'

// Wait until the dom is ready
$(function() {

  // Tooltips
  $(function() {
    tippy('.tippy', {
      position: 'top',
      arrow: true,
      arrowSize: 'small',
      animation: 'shift',
      delay: [100, 0],
      size: 'regular',
      theme: 'spaces',
      sticky: true,
      animateFill: false,
      zIndex: 10000
    })
  })

  // Team/account, spaces and share overlays
  new Overlays()

  // overflows
  new Overflows()

  // Copy to clipboard buttons
  new Clipboard('.copy-to-clipboard')
  $('.copy-to-clipboard').on('click', function(e) {
    e.preventDefault()
  })

  // Select input value onclick
  $('.select-on-click').on('click', function(e) {
    this.select()
  })
})
