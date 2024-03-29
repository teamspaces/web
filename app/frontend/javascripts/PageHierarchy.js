class PageHierarchy {

  constructor({page_hierarchy_url, csrf_token}) {
    this.page_hierarchy_url = page_hierarchy_url;
    this.csrf_token = csrf_token;
  };

  update(attributes){
    return fetch(this.page_hierarchy_url, {
      method: 'PATCH',
      body: JSON.stringify(attributes),
      headers: new Headers({
        'X-CSRF-Token': this.csrf_token,
        'Content-Type': 'application/json',
        'Accept':  'application/json' }),
      credentials: 'same-origin'
    });
  };
};

export default PageHierarchy;
