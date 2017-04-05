const RichText = require("rich-text");
const ShareDB = require("sharedb/lib/client");
      ShareDB.types.register(RichText.type);

class PageDB {

    constructor({ collab_url, collection, csrf_token, document_id, page_content_url }){
      this.collab_url = collab_url;
      this.collection = collection;
      this.csrf_token = csrf_token;
      this.document_id = document_id;
      this.page_content_url = page_content_url;

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

    save(content){
      console.log(content);

      $.ajax({
        url: this.page_content_url,
        headers: { "X-CSRF-Token": this.csrf_token },
        method: "PATCH",
        dataType: "json",
        data: {
            page_content: {
                contents: content,
            }
        },
        error: function(){  console.log( "error ") },
        success: function(){ console.log( "successs ")},
        complete: function(){}
      });
    }

}


export default PageDB
