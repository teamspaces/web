import QuillEditor from './quill_editor'
import PageSharedDB from './page/page_shared_db'
import PageDB from './page/page_db'

class Editor {

  constructor({ attachTo, options }) {
    this.pageDB       = new PageDB(options); // web_server
    this.pageSharedDB = new PageSharedDB(options); // collab_server
    this.quillEditor  = new QuillEditor({ attachTo: attachTo });

    this.attachQuillEditorEvents();
    this.attachPageDBEvents();
    this.attachPageSharedDBEvents();
  };

  attachQuillEditorEvents(){
    this.quillEditor.on('text-change', this.pageSharedDB.update.bind(this.pageSharedDB));
    this.quillEditor.on('text-save',   this.pageDB.update.bind(this.pageDB));
  };

  attachPageDBEvents(){
    this.pageDB.on('saved', (response) => console.log("Saved Content"));
    this.pageDB.on('error', (error)    => console.log("Error"));
  };

  attachPageSharedDBEvents(){
    this.pageSharedDB.on('subscribe', (content) => {
      this.quillEditor.enable();
      this.quillEditor.setContents(content);
    });

    this.pageSharedDB.on('update',    this.quillEditor.updateContents.bind(this.quillEditor));
    this.pageSharedDB.on('reconnect', this.quillEditor.disable.bind(this.quillEditor) );
  };
};

export default Editor
