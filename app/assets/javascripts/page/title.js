const SaveAfterMilliseconds = 500;

class PageTitle {

  constructor({attachTo, statusMessage, page}) {
    this.statusMessage = statusMessage;

    this.input = $(attachTo);
    this.page = page;

    this.addEventListeners();
  }

  title() {
    return this.input.text();
  }

  save() {
    this.page.update({title: this.title()})
        .then(response => this.statusMessage.update("Your changes have been saved."))
        .catch(error => Raven.captureException(error));
  }

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
  }

  clean() {
    let titleHtml = this.input.html().replace(/&nbsp;/g, ' ')
    let titleText = this.input.text()

    // Clean content if it's not plain text
    if(titleHtml.replace(/\s/g, '') != titleText.replace(/\s/g, '')) {
      this.input.html( titleText )

      this.moveCursorToEnd(this.input.get(0))
    }
  }

  moveCursorToEnd(contentEditableElement) {
    var range,selection;

    if(document.createRange)//Firefox, Chrome, Opera, Safari, IE 9+
    {
        range = document.createRange();//Create a range (a range is a like the selection but invisible)
        range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
        range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
        selection = window.getSelection();//get the selection object (allows you to change selection)
        selection.removeAllRanges();//remove any selections already made
        selection.addRange(range);//make the range you have just created the visible selection
    }
  }
}

export default PageTitle;
