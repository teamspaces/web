'use strict';

const TitleEditor = class TitleEditor {

  constructor(title_input, settings) {
    this.title_input = title_input;
    this.settings = settings;

    this.page_url = this.settings.page_url;
    this.csrf_token =  this.settings.csrf_token;
  };

  title(){
    return this.title_input.val();
  };

  observeAndSaveChanges(){
    this.observe(this.save.bind(this));
  };

  observe(onUpdate){
    var timer;

    this.title_input.keyup(() => {
        clearTimeout(timer);
        //wait then save
        timer = setTimeout(() => { onUpdate(); }, 700);
    });
  };

  save(){
        $.ajax({
            url: this.page_url,
            headers: { "X-CSRF-Token": this.csrf_token },
            method: "PATCH",
            dataType: "json",
            data: {
                page: {
                    title: this.title(),
                }
            },
            error: function(ola){
              console.log("SDFDF");
            },
            success: function(ola){
              console.log("SUCCESS");
            }
        });
  };
};

module.exports = TitleEditor;

