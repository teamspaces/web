const RichText = require("rich-text");
const ShareDB = require("sharedb/lib/client");
      ShareDB.types.register(RichText.type);
const EventEmitter = require('events');

class PageSharedContent extends EventEmitter {
    // emits page_subscribe
    // emits page_update
    // emits expired_token

    constructor({ collab_url, collection, document_id }){
     // this.collab_url = collab_url;
     // this.collection = collection;
     // this.document_id = document_id;
      super();

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
          this.webSocket.close();

          this.emit('expired_token');
        };

        console.log("VICOT");
        console.log(err.code);
        console.log(err);
      });

      this.page.on("op", (op, source) => {
        this.emit('page_update', op, source);
      });
    }

    update(delta, options){
      this.page.submitOp(delta,options);
    };
}


export default PageSharedContent