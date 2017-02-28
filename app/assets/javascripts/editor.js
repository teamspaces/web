(function(){
    const ShareDB = require("sharedb/lib/client");
    const RichText = require("rich-text");
    const Quill = require("quill");

    var Editor = function(){};

    var attachTo;
    var options;
    var webSocket;
    var shareDBConnection;
    var editor;
    var page;
    var contentsChanged = false;
    var calledSaveAt = 0.0;

    Editor.prototype.init = function(attachTo, pageSavingStatus, options) {
        this.attachTo = attachTo;
        this.pageSavingStatus = pageSavingStatus;
        this.options = options;

        this.registerOT();

        // Error out if the two steps below does not work.
        this.connectWebSocket();
        this.connectShareDB();

        this.bindWindowEvents();
        this.setupEditor();

        this.startAutoSaveCycle();

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
        base.debug("Window disconnected. Closing WebSocket and Disabling editor.");
        base.disableEditor();
        webSocket.close();

    }

    Editor.prototype.reconnect = function(){
        this.connectWebSocket();
        this.reconnectShareDB();
    }

    Editor.prototype.setupEditor = function(){
        /* https://quilljs.com/docs/configuration/ */
        var editorOptions = {
            theme: "snow",
            placeholder: "And write something awesome here...",
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

        this.editor = new Quill(this.attachTo, editorOptions);
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
            base.debug("Disabling editor, page subscribe failed with error:");
            base.debug(error);
            base.disableEditor();
            return false;
        }

        // Setup editor using all deltas for this page
        base.editor.setContents(base.page.data);

        // Changes made in the editor
        base.editor.on("text-change", function(delta, oldDelta, source) {
            if (source !== "user") return;
            base.page.submitOp(delta, {source: base.editor});

            // Trigger auto-save
            base.save();
        });

        // Let us know when there is no pending actions
        base.page.whenNothingPending(function(error) {
            if (error) {
                base.debug("Nothing pending error: " + error.message);
            } else {
                base.debug("Nothing pending.");
            }
        });

        // Update editor with new deltas coming from collab
        base.page.on("op", function(op, source) {
            if (source === base.editor) return;
            base.editor.updateContents(op);
        });

        // Caused by network errors or eg. jwt token expired
        base.page.on("error", function(error) {
            base.debug(error.code);
            base.debug(error.message);

            // We don't have access to this document
            if (error.code == 403) {
                base.editor.disable();
                base.debug("Disabling editor, access denied: " + error.message);
            } else {
                // What else do we want to handle? And how?
                base.debug("Unhandled error:" + error);
            }
        });
    }

    Editor.prototype.stillTyping = function() {
        var currentTime = window.performance.now();
        if (currentTime - base.calledSaveAt < 450) {
            return true;
        }

        return false;
    }

    Editor.prototype.editorHTMLContents = function() {
        return $(base.attachTo + " .ql-editor").html();
    }

    Editor.prototype.save = function() {
        base.calledSaveAt = window.performance.now();
        base.contentsChanged = true;
    }

    Editor.prototype.onSave = function() {
        if (!base.contentsChanged) {
            base.debug("No changes to be saved.");
            base.startAutoSaveCycle();
            return;
        }

        if (base.stillTyping()) {
            base.debug("Still typing, skipping until finished.");
            base.startAutoSaveCycle();
            return;
        }

        base.debug("Saving changes to page.");
        $.ajax({
            url: base.options.page_content_url,
            headers: { "X-CSRF-Token": base.options.csrf_token },
            method: "PATCH",
            dataType: "json",
            data: {
                page_content: {
                    contents: base.editorHTMLContents(),
                }
            },
            error: base.onSaveRequestError,
            success: base.onSaveRequestSuccess,
            complete: base.onSaveRequestComplete
        });
    }

    Editor.prototype.onSaveRequestError = function(request) {
        if(request.status == 404) {
            base.debug("Disabling editor, page not found");
            base.disableEditor();
        } else if (request.status == 403) {
            base.debug("Disabling editor, not authorized to this page");
            base.disableEditor();
        }

        base.pageSavingStatus.updateFailedToSave();
    }

    Editor.prototype.onSaveRequestSuccess = function() {
        base.contentsChanged = false;
        base.pageSavingStatus.updateSavedSuccessfully();
    }

    Editor.prototype.onSaveRequestComplete = function() {
        base.startAutoSaveCycle();
    }

    Editor.prototype.startAutoSaveCycle = function() {
        setTimeout(this.onSave, 500);
    }

    var base = module.exports = new Editor();
})();
