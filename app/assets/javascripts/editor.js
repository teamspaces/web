import QuillEditor from './quill_editor'
import PageSharedContent from './page/shared_content'
import PageContent from './page/content'

class Editor {

  constructor({ attachTo, options }) {
    this.pageContent = new PageContent(options);
    this.pageSharedContent = new PageSharedContent(options);

    this.quillEditor = new QuillEditor(attachTo,
                                       this.onEditorSave.bind(this),
                                       this.onLiveUpdate.bind(this));

    this.init();
  };

  init(){
    this.pageSharedContent.onPageSubscribe((content) => {
      this.quillEditor.enable();
      this.quillEditor.setContents(content);
    });
  };

  onLiveUpdate(delta, opts){
    this.pageSharedContent.page.submitOp(delta, opts)
  }

  onEditorSave(contents){
    this.pageContent.update(contents);
  }
};

export default Editor
