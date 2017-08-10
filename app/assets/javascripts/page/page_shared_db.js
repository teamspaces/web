// import * as log from 'loglevel'

const EventEmitter = require('events')
const ReconnectingWebSocket = require('reconnecting-websocket')

const RichText = require('rich-text')
const ShareDB = require('sharedb/lib/client')
      ShareDB.types.register(RichText.type)

// handles connection to collab_server
class PageSharedDB extends EventEmitter {
    // emits subscribe
    // emits update
    // emits error

    constructor(options){
      super()
      this.connect(options)
    }

    connect({ collab_url, collection, document_id, edit_page_url, csrf_token, expires_at}){
      // edit_page_url, csrf_token, expires_at are used to reconnect
      this.edit_page_url = edit_page_url
      this.csrf_token = csrf_token
      this.expires_at = expires_at

      this.webSocket = new ReconnectingWebSocket(collab_url, [], {
          debug: true,
          connectionTimeout: 750, // Milliseconds to wait for connection to open
          maxReconnectionDelay: 2500, // Max time waiting between reconnects
          minReconnectionDelay: 100, // Min time before reconnect
          reconnectionDelayGrowFactor: 1.3, // Rate of delaying reconnect
          maxRetries: (60* 60 * 24 * 7) // Max attempts
      })

      this.shareDBConnection = new ShareDB.Connection(this.webSocket)
      this.page = this.shareDBConnection.get(collection, document_id)

      this.attachPageEvents()
    }

    setReconnectTimer(){
      // tries to reconnect 3 seconds before jwt-token expires
      let reconnectInMilliseconds = (this.expires_at * 1000) - Date.now() - 3000
      clearTimeout(this.reconnect_timer)

      this.reconnect_timer = setTimeout(() => {
          this.reconnect()
      }, reconnectInMilliseconds)
    }

    reconnect(){
      this.fetchEditorSettings()
          .then((editor_settings) => {
            this.page.whenNothingPending((_error) => {

              this.webSocket.close()
              this.connect(editor_settings)
            })
          })
          .catch((error) => this.emit('error', error) )
    }

    fetchEditorSettings(){
      return  fetch(this.edit_page_url, {
                    method: 'GET',
                    headers: new Headers({
                      'X-CSRF-Token': this.csrf_token,
                      'Content-Type': 'application/json',
                      'Accept':  'application/json' }),
                    credentials: 'same-origin'})
        .then(response => response.json())
        .then(body => JSON.parse(body.editor_settings))
    }

    attachPageEvents(){
      this.webSocket.addEventListener('close', (_event) => {
        log.debug('WebSocket connection=close')
        this.emit('disconnect')
      })

      this.webSocket.addEventListener('open', (_event) => {
        log.debug('WebSocket connection=open')
        this.emit('connect')
      })

      this.page.on('error', (error) => {
        this.emit('error', error)
      })

      this.page.on('op', (op, source) => {
        this.emit('update', op, source)
      })

      this.page.subscribe((_error) => {
        this.emit('subscribe', this.page.data)
        this.setReconnectTimer()
      })
    }

    update(delta, options){
      this.page.submitOp(delta,options)
    }
}

export default PageSharedDB
