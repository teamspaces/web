class PageTitle {

  constructor({attachTo, statusMessage, page}) {
    this.statusMessage = statusMessage;

    this.input = $(attachTo);
    this.page = page;

    this.title = () => { return this.input.val() };

    this.addEventListeners();
  };

  addEventListeners(){
    this.onChange(() => {
      this.page.update({title: this.title()})
        .then(response => this.statusMessage.update("SAVED TITLE"))
        .catch(error => Raven.captureException(error));
    });
  };

  onChange(fn){
    let timer;

    this.input.keyup(() => {
        clearTimeout(timer);

        this.statusMessage.update("SAVING TITLE");
        // wait for more changes
        timer = setTimeout(() => { fn(); }, 350);
    });
  };
};

export default PageTitle;
