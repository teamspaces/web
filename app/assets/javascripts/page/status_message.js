class PageStatusMessage {

  constructor({ attachTo }) {
    this.text_field = $(attachTo)
  };

  update(msg){
    this.text_field.finish().text(msg)
  };
};

export default PageStatusMessage;
