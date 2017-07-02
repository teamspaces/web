const RichText = require('rich-text');
const ShareDB = require('sharedb/lib/client');
      ShareDB.types.register(RichText.type);
const EventEmitter = require('events');

// handles connection to collab_server
class PageSharedDB extends EventEmitter {
    // emits subscribe
    // emits update
    // emits error

    constructor(options){
      super();

      this.connect(options);
    };

    connect({ collab_url, collection, document_id, edit_page_url, csrf_token, expires_at}){
      // edit_page_url, csrf_token, expires_at are used to reconnect
      this.edit_page_url = edit_page_url;
      this.csrf_token = csrf_token;
      this.expires_at = expires_at;

      this.webSocket = new WebSocket(collab_url);
      this.shareDBConnection = new ShareDB.Connection(this.webSocket);
      this.page = this.shareDBConnection.get(collection, document_id);

      this.attachPageEvents();
    };

    setReconnectTimer(){
      // tries to reconnect 3 seconds before jwt-token expires
      let reconnectInMilliseconds = (this.expires_at * 1000) - Date.now() - 3000;
      clearTimeout(this.reconnect_timer);

      this.reconnect_timer = setTimeout(() => {
          this.reconnect();
      }, reconnectInMilliseconds);
    }

    reconnect(){
      this.fetchEditorSettings()
          .then((editor_settings) => {
            this.page.whenNothingPending((_error) => {

              this.webSocket.close();
              this.connect(editor_settings);
            });
          })
          .catch((error) => this.emit('error', error) );
    };

    fetchEditorSettings(){
      return  fetch(this.edit_page_url, {
                    method: 'GET',
                    headers: new Headers({
                      'X-CSRF-Token': this.csrf_token,
                      'Content-Type': 'application/json',
                      'Accept':  'application/json' }),
                    credentials: 'same-origin'})
        .then(response => response.json())
        .then(body => JSON.parse(body.editor_settings));
    };

    attachPageEvents(){
      this.webSocket.addEventListener('close', (_event) => {
        this.emit('disable_editor');
      });

      this.page.on('error', (error) => {
        this.emit('error', error);
      });

      this.page.on('op', (op, source) => {
        this.emit('update', op, source);
      });

      this.page.subscribe((_error) => {
        this.emit('subscribe', this.page.data);
        this.setReconnectTimer();
      });
    };

    update(delta, options){
      this.page.submitOp(delta,options);
    };
}

export default PageSharedDB