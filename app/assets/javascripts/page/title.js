const PageTitle = class PageTitle {

  constructor(input, page) {
    this.input = input;
    this.title = () => { return input.val() };

    this.page = page;
  };

  init(){
    this.onChange(() => {
      const promise = this.page.update({title: this.title()})

      promise
        .then(response => console.log("Successfully updated page title"))
        .catch(error => Raven.captureException(error));
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
