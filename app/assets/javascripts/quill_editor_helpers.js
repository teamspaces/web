import isWhitespace from 'is-whitespace';

export function clipboardURLMatcherFunc(linkReferences){
  return function(node, delta){
        var regex = /https?:\/\/[^\s]+/g;
        if(typeof(node.data) !== 'string') return;
        var matches = node.data.match(regex);

        let linkText = function(url){
          let lowered = url.toLowerCase();

          if(lowered.includes("lvh.me") || lowered.includes("spaces.is")){
            return "Loading ...";
          }else{
            return url;
          }
        };

        if(matches && matches.length > 0) {
            var ops = [];
            var str = node.data;

            matches.forEach(function(match) {
                var split = str.split(match);
                var beforeLink = split.shift();
                ops.push({ insert: beforeLink });
                ops.push({ insert: linkText(match), attributes: { link: match } });
                linkReferences.create(match);

                str = split.join(match);
            });
            ops.push({ insert: str });
            delta.ops = ops;
        }

        return delta;
      }
    };
