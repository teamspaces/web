const EventEmitter = require('events');

// performs requests to web_server
class PageDB extends EventEmitter {
  // emits saved
  // emits error

  constructor({ csrf_token, page_content_url }){
    super();

    this.csrf_token = csrf_token;
    this.page_content_url = page_content_url;
  }

  update(content){
    fetch(this.page_content_url, {
          method: 'PATCH',
          body: JSON.stringify({ page_content: { contents: content }}),
          headers: new Headers({
            'X-CSRF-Token': this.csrf_token,
            'Content-Type': 'application/json',
            'Accept':  'application/json' }),
          credentials: 'same-origin'
    }).then((response) => { this.emit('saved', response) })
      .catch((error)   => { this.emit('error', error) })
  }
};

export default PageDB;
