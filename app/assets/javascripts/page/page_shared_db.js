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
      this.subscribePageEvents()
    }

    connect({ collab_url, collection, document_id, edit_page_url, csrf_token, expires_at}){
      // edit_page_url, csrf_token, expires_at are used to reconnect
      this.edit_page_url = edit_page_url
      this.csrf_token = csrf_token
      this.expires_at = expires_at

      this.webSocket = new ReconnectingWebSocket(collab_url, [], {
          debug: true,
          connectionTimeout: 2000, // Milliseconds to wait for connection to open
          maxReconnectionDelay: 2500, // Max time waiting between reconnects
          minReconnectionDelay: 100, // Min time before reconnect
          reconnectionDelayGrowFactor: 1.3, // Rate of delaying reconnect
          maxRetries: (60* 60 * 24 * 7) // Max attempts
      })

      this.shareDBConnection = new ShareDB.Connection(this.webSocket)
      this.page = this.shareDBConnection.get(collection, document_id)

      this.subscribeWebSocketEvents()
      this.setupTokenReconnectTimer()
    }

    // Internal: Set timer to trigger JWT refresh.
    setupTokenReconnectTimer(){
      log.debug('[PageSharedDB] setting up timer for token refresh')
      let reconnectInMilliseconds = (this.expires_at * 1000) - Date.now() - 5000
      clearTimeout(this.tokenReconnectTimer)

      this.tokenReconnectTimer = setTimeout(() => {
          this.tokenReconnect()
      }, reconnectInMilliseconds)
    }

    tokenReconnect(){
      log.debug('[PageSharedDB] refreshing token and reconnecting')
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

    subscribeWebSocketEvents() {
      log.debug('[PageSharedDB] subscribing to websocket events')

      this.webSocket.addEventListener('close', (_event) => {
        log.debug('[PageSharedDB] disconnected')
        this.emit('disconnect')
      })

      this.webSocket.addEventListener('open', (_event) => {
        log.debug('[PageSharedDB] connected')
        this.emit('connect')
      })

      this.webSocket.addEventListener('error', (error) => {
        log.debug('[PageSharedDB] websocket error', error)
      })
    }

    subscribePageEvents(){
      log.debug('[PageSharedDB] subscribing to page events')

      this.page.on('error', (error) => {
        this.emit('error', error)
      })

      this.page.on('op', (op, source) => {
        this.emit('update', op, source)
      })

      this.page.subscribe((_error) => {
        log.debug('[PageSharedDB] subscribe emitted')
        this.emit('subscribe', this.page.data)
      })
    }

    update(delta, options){
      this.page.submitOp(delta,options)
    }
}

export default PageSharedDB
