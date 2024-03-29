const Quill = require("quill");
const EventEmitter = require('events');
import { clipboardURLMatcherFunc, liveAutolinkUrlsFunc } from './quill_editor_helpers'
import InlineTooltip from './InlineTooltip'
import InlineRow from './InlineRow'
import EditorClipboard from './EditorClipboard'

/* https://quilljs.com/docs/configuration/ */
const QuillOptions = {
  placeholder: "Write something here...",
  modules: {
    syntax: true,
    toolbar: false,
    inlineTooltip: [
      ['bold', 'italic', 'strike', 'underline', 'link'],
      [{'header': 2}, {'header': 3}, {'list': 'bullet'}, {'list': 'ordered'}, 'code-block']
    ],
    inlineRow: [
      {'header': 2}, {'header': 3}, {'list': 'bullet'}, {'list': 'ordered'}, 'code-block'
    ]
  }
};

const SaveAfterMilliseconds = 500;

class QuillEditor extends EventEmitter {
  // emits text-change with parameters: ( delta, { source: } )
  // emits text-save   with parameters: ( html_content )

  constructor({ attachTo }){
    super();

    this.attachTo = attachTo;
    this.editor = new Quill(attachTo, QuillOptions);

    this.addEditorMatchers();
    this.addEditorEvents();
    this.disable();
  };

  addEditorEvents(){
    let text_change_timer;

    this.editor.on('text-change', (delta, oldDelta, source) => {
      if (source !== 'user') return;

        this.emit('text-change', delta, {source: this.editor});
        liveAutolinkUrlsFunc(delta, this.editor);

        clearTimeout(text_change_timer);

        text_change_timer = setTimeout(() => {
          this.emit('text-save', this.contents());
        }, SaveAfterMilliseconds);
    });
  }

  addEditorMatchers(){
    // Clipboard URL Matcher
    this.editor.clipboard.addMatcher(Node.TEXT_NODE, clipboardURLMatcherFunc);
  };

  disable(){
    this.editor.disable();
  };

  enable(){
    this.editor.enable();
  };

  contents(){
    return $(this.attachTo + " .ql-editor").html();
  };

  setContents(contents){
    let current_selection = this.editor.getSelection();

    this.editor.setContents(contents);

    // jump to same position like before
    if(current_selection){
      this.editor.setSelection(current_selection);
    }
  };

  updateContents(op, source){
    if (source === this.editor) return;

    this.editor.updateContents(op);
  }
}

export default QuillEditor;
