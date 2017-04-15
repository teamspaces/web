class PageStatusMessage {

  constructor({ attachTo }) {
    this.text_field = $(attachTo);
  };

  update(msg){
    this.text_field.finish()
                   .show()
                   .text(msg)
                   .delay(1500).fadeOut(500);
  };
};

export default PageStatusMessage;
