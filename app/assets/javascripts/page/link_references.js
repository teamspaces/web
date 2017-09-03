class LinkReferences  {
  constructor({ csrf_token, link_references_url }){
    this.csrf_token = csrf_token;
    this.link_references_url = link_references_url;
  }

  create(link){
    fetch(this.link_references_url, {
          method: 'POST',
          body: JSON.stringify({ link: link }),
          headers: new Headers({
            'X-CSRF-Token': this.csrf_token,
            'Content-Type': 'application/json',
            'Accept':  'application/json' }),
          credentials: 'same-origin'
    })
    .then(response => response.json())
    .then((body) => {
      body.linkReferences.forEach((linkReference) => {
        $('a[href$="' + linkReference.link + '"]').text(linkReference.text);
      });
    })
  }
};

export default LinkReferences;
