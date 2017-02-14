'use strict';

const TitleEditor = class TitleEditor {

  constructor(title_input, settings) {
    this.title_input = title_input;
    this.settings = settings;
    this.url = this.settings.page_url;
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

    console.log("TE BESARE");
    console.log(title);
  };

  hello(){
    console.log(this.title_input);
    console.log(this.settings);
  };
};

module.exports = TitleEditor;

