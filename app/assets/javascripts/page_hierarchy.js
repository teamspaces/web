'use strict';

const PageHierarchy = class PageHierarchy {

  constructor(settings) {
    this.space_url = settings['page_hierarchy_url'];
    this.csrf_token = settings['csrf_token'];
  };

  update(attributes, success, error){
    $.ajax({
        url: this.space_url,
        headers: { "X-CSRF-Token": this.csrf_token },
        method: "PATCH",
        dataType: "json",
        data: attributes,
        success: function(data, textStatus, jqXHR){
          if(success){ success() }else{
            console.log("Successfully updated page hierarchy");
          }
        },
        error: function(jqXHR, textStatus, errorThrown){
          if(error){ error() }else{
            console.log("Could not update page hierarchy");
          }
        }
    });
  };
};

module.exports = PageHierarchy;
