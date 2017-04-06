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

  constructor(attachTo, onSaveFunc, onTextChange){
    this.attachTo = attachTo;
    this.editor = new Quill(attachTo, QuillOptions);
    this.contents = () => { return $(attachTo + " .ql-editor").html(); };

    this.addOnTextChange(onTextChange);
    this.addClipboardURLMatcher();
    this.disable();

    this.onChange(onSaveFunc);
  };

  addOnTextChange(onTextChange){
    this.editor.on("text-change", (delta, oldDelta, source) => {
      if (source !== "user") return;

        onTextChange(delta, {source: this.editor});

            //base.page.submitOp(delta, {source: base.editor});

            // Autolink URLs while typing
            //var regex = /https?:\/\/[^\s]+$/;
            //if(delta.ops.length === 2 && delta.ops[0].retain && isWhitespace(delta.ops[1].insert)) {
            //    var endRetain = delta.ops[0].retain;
            //    var text = base.editor.getText().substr(0, endRetain);
            //    var match = text.match(regex);
            //    if(match !== null) {
            //        var url = match[0];

            //        var ops = [];
            //        if(endRetain > url.length) {
            //            ops.push({ retain: endRetain - url.length });
            //        }

            //        ops = ops.concat([
            //            { delete: url.length },
            //            { insert: url, attributes: { link: url } }
            //        ]);

            //        base.editor.updateContents({
            //            ops: ops
            //        });
            //    }
            //}

            // Trigger auto-save
            //base.save();
    });
  }

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
