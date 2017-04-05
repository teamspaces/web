const Quill = require("quill");

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

const clipboardURLMatcherFunc = function(node, delta){
        var regex = /https?:\/\/[^\s]+/g;
        if(typeof(node.data) !== 'string') return;
        var matches = node.data.match(regex);

        if(matches && matches.length > 0) {
            var ops = [];
            var str = node.data;
            matches.forEach(function(match) {
                var split = str.split(match);
                var beforeLink = split.shift();
                ops.push({ insert: beforeLink });
                ops.push({ insert: match, attributes: { link: match } });
                str = split.join(match);
            });
            ops.push({ insert: str });
            delta.ops = ops;
        }

        return delta;
    };

class QuillEditor {

  constructor(attachTo, onSaveFunc){
    this.attachTo = attachTo;
    this.editor = new Quill(attachTo, QuillOptions);
    this.contents = () => { return $(attachTo + " .ql-editor").html(); };

    this.addClipboardURLMatcher();
    this.disable();

    this.onChange(onSaveFunc);
  };


  onChange(fn){
    let timer;

    $(this.attachTo).keyup(() => {
        clearTimeout(timer);
        //TODO verbessern checken wenn wirklich sich was verändert hat
        // wait for more changes
        timer = setTimeout(() => { fn(this.contents()); }, 350);
    });
  };

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
