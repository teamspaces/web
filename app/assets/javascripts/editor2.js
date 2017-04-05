import QuillEditor from './quill_editor'
import PageDB from './page_db'

class Editor {

  constructor({ attachTo, options }) {

    this.pageDB = new PageDB(options);
    this.quillEditor = new QuillEditor(attachTo, this.onEditorSave.bind(this));

    this.init();
  };

  init(){
    this.pageDB.onPageSubscribe((content) => {
      this.quillEditor.enable();
      console.log(content);
      this.quillEditor.setContents(content);
    });
    //this.page.subscribe((error) => {
      //error handling

    //  this.quillEditor.setContents(this.page.data);
    //  this.quillEditor.enable();

    //});
  };

  onEditorSave(contents){
    this.pageDB.save(contents);
  }



  //update(attributes){
  //  return fetch(this.page_url, {
  //    method: 'PATCH',
  //    body: JSON.stringify({ page: attributes }),
  //    headers: new Headers({
  //     'X-CSRF-Token': this.csrf_token,
  //      'Content-Type': 'application/json',
  //      'Accept':  'application/json' }),
  //    credentials: 'same-origin'
  //  })
  //};
};

export default Editor
