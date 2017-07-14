// This class extends Quill's Clipboard module to avoid scrolling on paste and insertion of new elements
// See https://codepen.io/quill/pen/XNJqav and https://github.com/quilljs/quill/issues/1082

import Quill from 'quill'
import $ from 'jquery'
const Clipboard = Quill.import('modules/clipboard');

class EditorClipboard extends Clipboard {
  onPaste(e) {
    const scrollTop = $(document).scrollTop()

    super.onPaste(e);

    setTimeout(function() {
      $(document).scrollTop(scrollTop)
    }, 10);
  }
}

// Register as a quill module
Quill.register('modules/clipboard', EditorClipboard, true)

export default EditorClipboard
