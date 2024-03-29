import tippy from 'tippy.js/dist/tippy'
import Clipboard from 'clipboard/dist/clipboard'

// Logger
import * as log from 'loglevel'
window.log = log

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
