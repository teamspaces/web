'use strict';

const PageTitle = class PageTitle {

  constructor(input, page) {
    this.input = input;
    this.title = () => { return input.val() };

    this.page = page;
  };

  init(){
    this.onChange(() => {
      this.page.update({title: this.title()});
    });
  };

  onChange(fn){
    let timer;

    this.input.keyup(() => {
        clearTimeout(timer);
        // wait for more changes
        timer = setTimeout(() => { fn(); }, 700);
    });
  };
};

module.exports = PageTitle;
