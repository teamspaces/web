const RichText = require("rich-text");
const ShareDB = require("sharedb/lib/client");
      ShareDB.types.register(RichText.type);
const EventEmitter = require('events');

class PageSharedContent extends EventEmitter {
    // emits page_subscribe
    // emits page_update
    // emits reconnect

    constructor(options){
      super();

      this.connect(options);
    };

    connect({ collab_url, collection, document_id, url, csrf_token}){
      // url and csrf_token are used to reconnect
      this.url = url;
      this.csrf_token = csrf_token;

      this.webSocket = new WebSocket(collab_url);
      this.shareDBConnection = new ShareDB.Connection(this.webSocket);
      this.page = this.shareDBConnection.get(collection, document_id);

      this.attachPageEvents();
    };

    reconnect(){
      this.emit('reconnect');
      this.webSocket.close();

      this.fetchEditorSettings()
          .then((editor_settings) => this.connect(editor_settings))
          .catch((error) => console.log("Error reconnecting") );
    };

    fetchEditorSettings(){
      return  fetch(this.url, {
                    method: 'GET',
                    headers: new Headers({
                      'X-CSRF-Token': this.csrf_token,
                      'Content-Type': 'application/json',
                      'Accept':  'application/json' }),
                    credentials: 'same-origin'})
        .then(r => r.json())
        .then(response => JSON.parse(response.editor_settings));
    };

    attachPageEvents(){
      this.page.on('error', (error) => {
        switch(error.code) {
          case 405: // invalid or expired token
            this.reconnect();
          case 403: // not authorized
            this.emit('not-authorized');
        };
      });

      this.page.on('op', (op, source) => {
        this.emit('page_update', op, source);
      });

      this.page.subscribe((_error) => {
        this.emit('page_subscribe', this.page.data);
      });
    };

    update(delta, options){
      this.page.submitOp(delta,options);
    };
}


export default PageSharedContent
