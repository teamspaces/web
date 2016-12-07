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

    Editor.prototype.init = function(attach_to, options) {
        this.attach_to = attach_to;
        this.options = options;

        this.registerOT();

        // Error out if the two steps below does not work.
        this.connectWebSocket();
        this.connectShareDB();

        this.bindWindowEvents();
        this.setupEditor();
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
            base.publishContents();
        });

        // Update editor with new deltas coming from collab
        base.page.on('op', function(op, source) {
            if (source === base.editor) return;
            base.editor.updateContents(op);
        });

        base.page.on('error', function(error) {
            // We don't have access to this document
            if (error.code == 403) {
                base.editor.disable();
                base.debug("Disabling editor, received access denied to page:" + error.message);
            } else {
                // What else do we want to handle? And how?
                base.debug("Unhandled error:", error);
            }
        });
    }

    Editor.prototype.sendSaveRequest = function() {
        base.saveInProgress = true;
        base.resetWaitingTimer();

        base.saveRequest = $.ajax({
            url: base.options.page_content_url,
            headers: { "X-CSRF-Token": base.options.csrf_token },
            method: "PATCH",
            dataType: "json",
            data: {
                page_content: {
                    contents: base.editor.getText()
                }
            },
            error: base.onSaveRequestError,
            success: base.onSaveRequestSuccess,
            complete: base.onSaveRequestComplete
        });
    }

    Editor.prototype.onSaveRequestError = function(request, status, _error) {
        if(request.status == 404) {
            base.debug("Disabling editor, page not found");
            base.disableEditor();
        } else if (request.status == 403) { // TODO: Should it be 403?
            base.debug("Disabling editor, not authorized to this page");
            base.disableEditor();
        } else if (status == "abort") {
            base.debug("Save request aborted");
        } else {
            base.debug("Unable to save page, triggering retry using timer");
            base.startSaveTimer();
        }
    }

    Editor.prototype.onSaveRequestSuccess = function() {
        base.debug("Saved changes.");
        base.lastSaveRequestFinishedAt = new Date().getTime();
    }

    Editor.prototype.onSaveRequestComplete = function() {
        base.resetSaveInProgress();
    }

    Editor.prototype.isSavingTooFrequent = function() {
        var currentTime = new Date().getTime();
        if (!lastSaveRequestFinishedAt) {
            return false;
        } else if (currentTime - lastSaveRequestFinishedAt >= 1500) {
            return false;
        }

        return true;
    }

    Editor.prototype.abortSaveRequest = function() {
        base.saveRequest.abort();
        base.resetSaveInProgress();
    }

    var isWaitingForTimer = false;
    var saveInProgress = false;
    var lastSaveRequestFinishedAt;

    Editor.prototype.startSaveTimer = function() {
        if (base.isWaitingForTimer === true) {
            base.debug("Halting save, there is already a timer running")
            return;
        } else {
            base.isWaitingForTimer = true;
        }

        base.debug("Starting timer to publish contents")
        setTimeout(base.publishContents,
                   1500 + 10)
    }

    Editor.prototype.resetWaitingTimer = function() {
        base.isWaitingForTimer = false;
    }

    Editor.prototype.resetSaveInProgress = function() {
        base.saveRequest = null;
        base.saveInProgress = false;
    }

    Editor.prototype.publishContents = function(){
        if (base.isWaitingForTimer === true) {
            base.debug("Timer running, ignoring request to publish contents")
            return;
        }

        if (base.saveInProgress === true) {
            base.abortSaveRequest() ;
            base.sendSaveRequest();
        } else {
            if (base.isSavingTooFrequent()) {
                base.startSaveTimer();
            } else {
                base.resetWaitingTimer();
                base.sendSaveRequest();
            }
        }
    }

    var base = module.exports = new Editor();
})();
