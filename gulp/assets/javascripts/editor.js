(function(){
  const ShareDB = require('sharedb/lib/client');
  const RichText = require('rich-text');
  const Quill = require('quill');

  var Editor = function(){};

  Editor.prototype.init = function(attach_to, options) {
    // TODO: Use a proper logger instead...
    console.log("Editor initialized with options:");
    console.log(attach_to);
    console.log(options);

    ShareDB.types.register(RichText.type);
    var socket = new WebSocket(options.collab_url);
    var connection = new ShareDB.Connection(socket);

    // Is this the way to do it?
    window.disconnect = function() {
      connection.close();
    };
    window.connect = function() {
      // DRY this (same code above)
      var socket = new WebSocket(options.collab_url);
      connection.bindToSocket(socket);
    };

    var page = connection.get(options.collection, options.document_id);
    page.subscribe(function(error) {
      if (error) throw error;
      var quill = new Quill(attach_to, {theme: 'snow'});
      quill.setContents(page.data);
      quill.on('text-change', function(delta, oldDelta, source) {
        if (source !== 'user') return;
        page.submitOp(delta, {source: quill});
      });
      page.on('op', function(op, source) {
        if (source === quill) return;
        quill.updateContents(op);
      });
    });
  }

  module.exports = new Editor();
})();
