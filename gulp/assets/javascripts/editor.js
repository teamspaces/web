(function(){
    const ShareDB = require('sharedb/lib/client');
    const RichText = require('rich-text');
    const Quill = require('quill');

    var Editor = function(){};

    var attach_to;
    var options;
    var webSocket;
    var shareDBConnection;
    var editor;
    var page;
    var contentsChanged;

    Editor.prototype.init = function(attach_to, options) {
        this.attach_to = attach_to;
        this.options = options;

        this.registerOT();

        // Error out if the two steps below does not work.
        this.connectWebSocket();
        this.connectShareDB();

        this.bindWindowEvents();
        this.setupEditor();
        this.setupAutoSave();

        // Eg. If someone deleted this page, we need to display a nice message
        // to the user. We can ask them to reload the page and let the Rails
        // controller redirect the user back to the Space with an error message
        // if the page has been removed.
        this.setupPage();
    }

    Editor.prototype.debug = function(message){
        console.log(message);
    }

    Editor.prototype.registerOT = function(){
        ShareDB.types.register(RichText.type);
    }

    Editor.prototype.connectWebSocket = function(){
        this.webSocket = new WebSocket(this.options.collab_url);
    }

    Editor.prototype.connectShareDB = function(){
        this.shareDBConnection = new ShareDB.Connection(this.webSocket);
    }

    Editor.prototype.reconnectShareDB = function(){
        this.shareDBConnection.bindToSocket(this.webSocket);
    }

    Editor.prototype.bindWindowEvents = function(){
        window.disconnect = this.disconnect;
    }

    Editor.prototype.disconnect = function(){
        webSocket.close();
    }

    Editor.prototype.reconnect = function(){
        this.connectWebSocket();
        this.reconnectShareDB();
    }

    Editor.prototype.setupEditor = function(){
        this.editor = new Quill(this.attach_to, { theme: "snow" });
    }

    Editor.prototype.enableEditor = function(){
        this.editor.enable();
    }

    Editor.prototype.disableEditor = function(){
        this.editor.disable();
    }

    Editor.prototype.setupPage = function(){
        this.page = this.shareDBConnection.get(this.options.collection,
                                               this.options.document_id);

        this.page.subscribe(this.onPageSubcribe);
    }

    Editor.prototype.onPageSubcribe = function(error){
        if (error) {
            this.debug("Disabling editor, page subscribe failed with error:");
            this.debug(error);
            this.disableEditor();
            return false;
        }

        // Setup editor using all deltas for this page
        base.editor.setContents(base.page.data);

        // Changes made in the editor
        base.editor.on('text-change', function(delta, oldDelta, source) {
            if (source !== 'user') return;
            base.page.submitOp(delta, {source: base.editor});

            // Trigger auto-save
            base.contentsChanged = true;
        });

        // Update editor with new deltas coming from collab
        base.page.on('op', function(op, source) {
            if (source === base.editor) return;
            base.editor.updateContents(op);
        });

        // Caused by network errors or eg. jwt token expired
        base.page.on('error', function(error) {
            base.debug(error.code);
            base.debug(error.message);

            // We don't have access to this document
            if (error.code == 403) {
                base.editor.disable();
                base.debug("Access denied:" + error.message);
            } else {
                // What else do we want to handle? And how?
                base.debug("Unhandled error:", error);
            }
        });
    }

    Editor.prototype.setupAutoSave = function(){
        setInterval(this.onAutoSave, 2000);
    }

    Editor.prototype.onAutoSave = function(){
        base.debug("Checking if we should auto-save.");

        if(base.contentsChanged == true){
            base.debug("Saving changes to page.");

            // Prevent overlapping saves
            base.contentsChanged = false;

            $.ajax({
                url: base.options.page_content_url,
                type: "PATCH",
                dataType: "json",
                headers: { "X-CSRF-Token": base.options.csrf_token },
                error: function(){
                    // Errors should make sure we try to save again on next tick
                    base.debug("Unable to save page, re-triggering save.");
                    base.contentsChanged = true;
                    // TODO: We just want to retry a number of times before we stop
                    // Eg. if document has been deleted, this is nuking the servers
                    // with failing requests. Best if server can respond that
                    // the content has been destroyed/does not exist. We dont
                    // want to stop on eg. 500 errors.
                },
                success: function(){
                    base.debug("Saved changes.");
                },
                data: {
                    page_content: {
                        contents: base.editor.getText()
                    }
                }
            });
        }
    }

    var base = module.exports = new Editor();
})();
