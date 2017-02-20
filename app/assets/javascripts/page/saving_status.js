class PageSavingStatus {

  constructor(text_field) {
    this.text_field = text_field;
  };

  updateSavedSuccessfully(){
    this.update('Saved');
  };

  updateFailedToSave(){
    this.update('Failed to Save');
  };

  update(msg){
    this.text_field.show()
                   .text(msg)
                   .delay(1200).fadeOut(500);
  };
};

export default PageSavingStatus;
