Spaces = window.Spaces || {};
Spaces.Editors = Spaces.Editors || {};

(function(){
  'use strict';

  var ShareDB = require('sharedb/lib/client');
  var RichText = require('rich-text');
  var Quill = require('quill');

  Spaces.Editors.Quill = function(options){
    var base = this;
    var options = {};
    var connected = false;
    var reconnecting = false;
    var socket;
    var shareDB;

    this.init = function(options){
      console.log("Editor: initialized with options:", options);
      this.options = options;
      this.initShareDB();
      this.connect();
    };

    this.initShareDB = function(){
      console.log("Editor: registering RichText.type as OT protocol");
      ShareDB.types.register(RichText.type);
    };

    this.connect = function(){
      var token = retrieveToken();
      var socketUrl = buildSocketUrl(options.token);

      console.log("Editor: connecting WebSocket to " + socketUrl);
      this.socket = new WebSocket(socketUrl);
      socket.onopen = socketOpenHandler();
      socket.onerror = socketErrorHandler();
    };

    this.socketOpenHandler = function(){
      if(!shareDB){
        console.log("Editor: creating new ShareDB client");
        this.shareDB = new ShareDB.Connection(socket);
      } else {
        console.log("Editor: re-using ShareDB client");
        shareDB.bindToSocket(socket);
      }
    };

    this.socketErrorHandler() = function(error){
      // Catch error and notify us?
    };

    this.socketCloseHandler() = function(){
      // TODO: initiate re-connection? Emit event for UI to change?
    };

    this.disconnect = function(){
      // connected = false
      // reconnecting = false
    };

    this.reconnect = function(){
      // Exponential backoff, can we use eg. node-retry?
      // https://www.npmjs.com/package/recovery looks best.
      // Start out with async.retry (we already load this..)
    };

    this.buildSocketUrl(token){
      options.collab_url.replace('{token}', token);
    };

    this.retrieveToken = function(){
      if(isTokenExpiring()){
        refreshToken();
      }

      return this.token;
    };

    this.refreshToken(){
      // { expires_at ..., token: }
      // tokenExpiresAt =
      // token =
    };

    this.isTokenExpiring(){
      // tokenExpiresAt within 1min
    };

    return this.init(options);
  };
})
