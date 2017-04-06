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

  constructor(attachTo, onSaveFunc, onTextChange){
    this.attachTo = attachTo;
    this.editor = new Quill(attachTo, QuillOptions);
    this.contents = () => { return $(attachTo + " .ql-editor").html(); };

    this.addOnTextChange(onTextChange);
    this.addClipboardURLMatcher();
    this.disable();

    this.onSaveFunc = onSaveFunc;
  };

  addOnTextChange(onTextChange){
    let timer;

    this.editor.on("text-change", (delta, oldDelta, source) => {
      if (source !== "user") return;

        onTextChange(delta, {source: this.editor});
        liveAutolinkUrlsFunc(delta, this.editor);

        clearTimeout(timer);
        timer = setTimeout(() => { this.onSaveFunc(this.contents()); }, 350);
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
  }
}


export default QuillEditor;
