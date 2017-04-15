const RichText = require("rich-text");
const ShareDB = require("sharedb/lib/client");
      ShareDB.types.register(RichText.type);
const EventEmitter = require('events');

class PageSharedContent extends EventEmitter {
    // emits page_subscribe
    // emits page_update
    // emits expired_token

    constructor(options){
      super();

      this.url = options.url;
      this.csrf_token = options.csrf_token;

      this.init_connection(options);
    };

    init_connection({ collab_url, collection, document_id, url, csrf_token }){
      this.webSocket = new WebSocket(collab_url);
      this.shareDBConnection = new ShareDB.Connection(this.webSocket);
      this.page = this.shareDBConnection.get(collection, document_id);

      this.page.subscribe((error) => {
        //if (error) {
        //  console.log("error");
        //  console.log(error);
       // }

        this.emit('page_subscribe', this.page.data);
      });

      this.page.on('error', (err) => {
        if(err.code == 405){


          this.emit('expired_token');
          this.reconnect();
        };

        console.log("VICOT");
        console.log(err.code);
        console.log(err);
      });

      this.page.on("op", (op, source) => {
        this.emit('page_update', op, source);
      });
    };

    reconnect(){
      this.webSocket.close();

      console.log("reconnect");

      fetch(this.url, {
        method: 'GET',
        headers: new Headers({
          'X-CSRF-Token': this.csrf_token,
          'Content-Type': 'application/json',
          'Accept':  'application/json' }),
        credentials: 'same-origin'
      }).then(r => r.json())
        .then(response => {
          this.init_connection(JSON.parse(response.editor_settings));
      });
    };

    update(delta, options){
      this.page.submitOp(delta,options);
    };
}


export default PageSharedContent
