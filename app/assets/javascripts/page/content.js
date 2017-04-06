class PageContent {

  constructor({ csrf_token, page_content_url }){
      this.csrf_token = csrf_token;
      this.page_content_url = page_content_url;
  }

  update(content){
    $.ajax({
      url: this.page_content_url,
      headers: { "X-CSRF-Token": this.csrf_token },
      method: "PATCH",
      dataType: "json",
      data: {
          page_content: {
              contents: content,
          }
      },
      error: function(){  console.log( "error ") },
      success: function(){ console.log( "successs ")},
      complete: function(){}
    });
  }
};

export default PageContent;
