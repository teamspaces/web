import isWhitespace from 'is-whitespace';

export function clipboardURLMatcherFunc(node, delta){
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

export function liveAutolinkUrlsFunc (delta, editor){
  var regex = /https?:\/\/[^\s]+$/;
  if(delta.ops.length === 2 && delta.ops[0].retain && isWhitespace(delta.ops[1].insert)) {
    var endRetain = delta.ops[0].retain;
    var text = editor.getText().substr(0, endRetain);
    var match = text.match(regex);
    if(match !== null) {
      var url = match[0];

      var ops = [];
      if(endRetain > url.length) {
        ops.push({ retain: endRetain - url.length });
      }

      ops = ops.concat([{ delete: url.length },
                        { insert: "MIGOS WETTER THAN THE OCEAN", attributes: { link: url } } ]);

      editor.updateContents({ ops: ops });
    }
  }
}
