class PageSavingStatus {

  constructor(text_field) {
    this.text_field = text_field;
  };

  update(state){
    this.text_field.show();

    if(state == 'saving'){
      this.text_field.text('Saving');
    }else if(state == 'saved'){
      this.text_field.text('Saved');
    };

    this.text_field.delay(1200).fadeOut(500);
  };
};

export default PageSavingStatus;
