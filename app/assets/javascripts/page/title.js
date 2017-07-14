const SaveAfterMilliseconds = 500;

class PageTitle {

  constructor({attachTo, statusMessage, page}) {
    this.statusMessage = statusMessage;

    this.input = $(attachTo);
    this.page = page;

    this.addEventListeners();
  };

  clean() {
    // TODO Clean input and keep caret position
    // this.input.html( this.input.text() );
  }

  title() {
    return this.input.text();
  }

  save() {
    this.page.update({title: this.title()})
        .then(response => this.statusMessage.update("All changes have been saved."))
        .catch(error => Raven.captureException(error));
  };

  addEventListeners() {
    this.input.on('input', (e) => {
        this.clean();

        this.statusMessage.update("Saving...");

        clearTimeout(this.title_change_timer);

        // wait for more changes
        this.title_change_timer = setTimeout(() => {
          this.save();
        }, SaveAfterMilliseconds);
    });
  };
};

export default PageTitle;
