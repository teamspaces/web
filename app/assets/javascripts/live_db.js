'use strict';

const ShareDB = require("sharedb/lib/client");
const LiveDB = class LiveDB {

  constructor(endpoint_url) {
    this.webSocket = new WebSocket(endpoint_url);
    this.shareDBConnection = new ShareDB.Connection(this.webSocket);
  };

  subscribe(collection, document_id, func, callback){
    connection = this.shareDBConnection.get(collection, document_id);
    connection.subscribe(func);

    callback(connection, nil);
  };
};

module.exports = LiveDB;
