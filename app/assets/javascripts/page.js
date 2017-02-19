'use strict';

const Page = class Page {

  constructor({ page_url, csrf_token }) {
    this.page_url = page_url;
    this.csrf_token = csrf_token;
  };

  update(attributes, success, error){
    $.ajax({
        url: this.page_url,
        headers: { "X-CSRF-Token": this.csrf_token },
        method: "PATCH",
        dataType: "json",
        data: { page: attributes },
        success: function(data, textStatus, jqXHR){
          if(success){ success() }else{
            console.log("Successfully updated page");
          }
        },
        error: function(jqXHR, textStatus, errorThrown){
          if(error){ error() }else{
            console.log("Could not update page");
          }
        }
    });
  };
};

module.exports = Page;
