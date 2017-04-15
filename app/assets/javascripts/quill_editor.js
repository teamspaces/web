const Quill = require("quill");
const EventEmitter = require('events');
import { clipboardURLMatcherFunc, liveAutolinkUrlsFunc } from './quill_editor_helpers'

/* https://quilljs.com/docs/configuration/ */
const QuillOptions = { theme: "snow",
             placeholder: "And write something here...",
             modules: {
                syntax: true,
                toolbar: [
                  [{ "header": [2, 3, 4, false] }],
                  ["bold", "italic", "underline", "strike"],
                  [{ "list": "ordered"}, { "list": "bullet" }],
                  ["link", "code-block"],
                  ["clean"]
                ]
            }
        };

const SaveAfterMilliseconds = 350;

class QuillEditor extends EventEmitter {
  // emits text-change with parameters: ( delta, { source: } )
  // emits text-save   with parameters: ( html_content )

  constructor({ attachTo }){
    super();

    this.attachTo = attachTo;
    this.editor = new Quill(attachTo, QuillOptions);

    this.addEditorEvents();
    this.addEditorMatchers();
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
    this.editor.setContents(contents);
  };

  updateContents(op, source){
    if (source === this.editor) return;

    this.editor.updateContents(op);
  }
}


export default QuillEditor;
