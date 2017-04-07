const Quill = require("quill");
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

class QuillEditor {

  constructor({ attachTo, onSaveTextChange, onSaveCompleteText} ){
    this.attachTo = attachTo;
    this.onSaveTextChange = onSaveTextChange;
    this.onSaveCompleteText = onSaveCompleteText;

    this.editor = new Quill(attachTo, QuillOptions);
    this.contents = () => { return $(attachTo + " .ql-editor").html(); };

    this.addOnTextChange();
    this.addClipboardURLMatcher();
    this.disable();
  };

  addOnTextChange(){
    let timer;

    this.editor.on("text-change", (delta, oldDelta, source) => {
      if (source !== "user") return;

        this.onSaveTextChange(delta, {source: this.editor});
        liveAutolinkUrlsFunc(delta, this.editor);

        clearTimeout(timer);
        timer = setTimeout(() => { this.onSaveCompleteText(this.contents()); }, 350);
    });
  }

  addClipboardURLMatcher(){
    this.editor.clipboard.addMatcher(Node.TEXT_NODE, clipboardURLMatcherFunc);
  };

  disable(){
    this.editor.disable();
  };

  enable(){
    this.editor.enable();
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
