const SaveAfterMilliseconds = 500;

class PageTitle {

  constructor({attachTo, statusMessage, page}) {
    this.statusMessage = statusMessage;

    this.input = $(attachTo);
    this.page = page;

    this.addEventListeners();
  };

  title(){
    return this.input.val();
  }

  save(){
    this.page.update({title: this.title()})
        .then(response => this.statusMessage.update("SAVED"))
        .catch(error => Raven.captureException(error));
  };

  addEventListeners(){
    let title_change_timer;

    this.input.keyup(() => {
        clearTimeout(title_change_timer);

        this.statusMessage.update("SAVING...");

        // wait for more changes
        title_change_timer = setTimeout(() => {
          this.save();
        }, SaveAfterMilliseconds);
    });
  };
};

export default PageTitle;
