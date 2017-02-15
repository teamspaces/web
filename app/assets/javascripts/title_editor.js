'use strict';

const TitleEditor = class TitleEditor {

  constructor(title_input, page) {
    this.title_input = title_input;
    this.title = () => { return title_input.val() };

    this.page = page;
  };

  init(){
    this.onTitleChange(() => {
      this.page.update({title: this.title()});
    });
  };

  onTitleChange(fn){
    let timer;

    this.title_input.keyup(() => {
        clearTimeout(timer);
        // wait for more changes
        timer = setTimeout(() => { fn(); }, 700);
    });
  };
};

module.exports = TitleEditor;

