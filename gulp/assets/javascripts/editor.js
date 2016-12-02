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
            console.log("Saving changes to page.");

            // Prevent overlapping saves
            contentsChanged = false;

            // Lets save the page contents
            $.ajax({
                url: options.page_content_url,
                type: "PATCH",
                dataType: "json",
                headers: { "X-CSRF-Token": options.csrf_token },
                error: function(){
                    // Errors should make sure we try to save again on next tick
                    console.log("Unable to save page, re-triggering save.");
                    contentsChanged = true;
                    // TODO: We just want to retry a number of times before we stop
                },
                success: function(){
                    console.log("Saved changes.");
                },
                data: {
                    page_content: {
                        contents: quill.getText()
                    }
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
            console.log(error.code);
            console.log(error.message);

            // We don't have access to this document
            if (error.code == 403) {
                quill.disable();
                console.log("Access denied:" + error.message);
            } else {
                // What else do we want to handle? And how?
                console.log("Unhandled error:", error);
            }
        });
    });
  }

  module.exports = new Editor();
})();
