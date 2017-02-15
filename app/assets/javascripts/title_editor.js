'use strict';

const TitleEditor = class TitleEditor {

  constructor(title_input, settings, db) {
    this.title_input = title_input;
    this.settings = settings;
    this.url = this.settings.page_url;
    console.log(db);
  };

  observeAndSaveChanges(){
    this.observe(this.save.bind(this));
  };

  observe(cb){
    var timer;

    this.title_input.keyup(() => {
        clearTimeout(timer);
        //wait then save
        timer = setTimeout(() => { cb(); }, 700);
    });
  };

  save(){
    var title = this.title_input.val();

        $.ajax({
            url: this.url,
            headers: { "X-CSRF-Token": this.settings.csrf_token },
            method: "PATCH",
            dataType: "json",
            data: {
                page: {
                    title: title,
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

  hello(){
    console.log(this.title_input);
    console.log(this.settings);
  };
};

module.exports = TitleEditor;

