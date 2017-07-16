import QuillEditor from './quill_editor'
import PageSharedDB from './page/page_shared_db'
import PageDB from './page/page_db'

class Editor {

  constructor({ attachTo, statusMessage, options }) {
    this.statusMessage = statusMessage;

    this.pageDB       = new PageDB(options); // web_server
    this.pageSharedDB = new PageSharedDB(options); // collab_server
    this.quillEditor  = new QuillEditor({ attachTo: attachTo });

    this.attachQuillEditorEvents();
    this.attachPageDBEvents();
    this.attachPageSharedDBEvents();
  };

  attachQuillEditorEvents(){
    // gets called on every change
    this.quillEditor.on('text-change', this.pageSharedDB.update.bind(this.pageSharedDB));
    this.quillEditor.on('text-change', () => this.statusMessage.update("Saving..."));
    // gets called 500 milliseconds after changes have been made
    this.quillEditor.on('text-save', this.pageDB.update.bind(this.pageDB));
  };

  attachPageDBEvents(){ // web_server events
    this.pageDB.on('saved', (response) => this.statusMessage.update("All changes have been saved"));
    this.pageDB.on('error', (error) => {
      console.log(error);
      Raven.captureException(error);
      this.quillEditor.disable();
    });
  };

  attachPageSharedDBEvents(){ // collab_server events
    this.pageSharedDB.on('subscribe', (content) => {
      this.quillEditor.enable();
      this.quillEditor.setContents(content);
    });

    this.pageSharedDB.on('update', this.quillEditor.updateContents.bind(this.quillEditor));
    this.pageSharedDB.on('error', (error) => {
      console.log(error);
      Raven.captureException(error);
      this.quillEditor.disable();
    });
    this.pageSharedDB.on('disable_editor', () => this.quillEditor.disable());
  };
};

export default Editor
