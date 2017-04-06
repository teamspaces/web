const RichText = require("rich-text");
const ShareDB = require("sharedb/lib/client");
      ShareDB.types.register(RichText.type);

class PageSharedContent {

    constructor({ collab_url, collection, document_id }){
     // this.collab_url = collab_url;
     // this.collection = collection;
     // this.document_id = document_id;

      this.webSocket = new WebSocket(collab_url);
      this.shareDBConnection = new ShareDB.Connection(this.webSocket);
      this.page = this.shareDBConnection.get(collection, document_id);
    }

    onPageSubscribe(func){
      this.page.subscribe((error) => {
        if (error) {

          console.log("ererer");
          console.log(error);
          //base.debug("Page subscribe failed with error:");
          //base.debug(error);
          //base.disableEditor();
          //return false;


        }

        func(this.page.data);
      })
    };
}


export default PageSharedContent
