'use strict';

const Page = class Page {

  constructor({ page_url, csrf_token }) {
    this.page_url = page_url;
    this.csrf_token = csrf_token;
  };

  update(attributes){
    return fetch(this.page_url, {
      method: 'PATCH',
      body: JSON.stringify({ page: attributes }),
      headers: new Headers({
        "X-CSRF-Token": this.csrf_token,
        'Content-Type': 'application/json' }),
      credentials: 'include',
      redirect: 'manual'
    })
  };
};

module.exports = Page;
