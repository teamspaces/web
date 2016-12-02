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

    // Create the quill editor
    var quill = new Quill(attach_to, {theme: 'snow'});

    // This could fail as the document does not exist
    var page = connection.get(options.collection, options.document_id);

    // Use this to trigger saves
    var contentsChanged = false;

    page.subscribe(function(error) {
      if (error) {
        console.log("Unable to subscribe to page.");
        quill.disable();
      }

    setInterval(function(){
        console.log("Checking if we should auto-save.");

        if(contentsChanged == true){
            // Prevent overlapping saves
            contentsChanged = false;

            console.log("Saving changes to page.");

            // Lets save the page contents
            $.ajax({
                url: "/page/123/contents", // TODO: lets use a real URl...
                type: "PATCH",
                error: function(){
                    // Errors should make sure we try to save again on next tick
                    console.log("Unable to save page, re-triggering save.");
                    contentsChanged = true;
                },
                data: {
                    contents: quill.getText()
                }
            });
        }
    }, 2000);

      // Setup quill using all deltas for this page
      quill.setContents(page.data);

      // Changes made in the editor
      quill.on('text-change', function(delta, oldDelta, source) {
        if (source !== 'user') return;
        page.submitOp(delta, {source: quill});

        // Trigger auto-save
        contentsChanged = true;
      });

      // Update quill with new deltas coming from collab
      page.on('op', function(op, source) {
        if (source === quill) return;
        quill.updateContents(op);
      });

      // Caused by network errors or eg. jtw token expired
      page.on('error', function(error) {
          if (error == "Error: 403: Invalid or expired token"){
              console.log("JWT IS NOT VALID, DISABLING EDITOR");
              quill.disable();
          }
      });
    });
  }

  module.exports = new Editor();
})();
