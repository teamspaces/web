import QuillEditor from './quill_editor'
import PageSharedContent from './page/shared_content'
import PageContent from './page/content'

class Editor {

  constructor({ attachTo, options }) {
    this.pageContent       = new PageContent(options);
    this.pageSharedContent = new PageSharedContent(options);
    this.quillEditor       = new QuillEditor({ attachTo: attachTo });

    this.attachQuillEditorEvents();
    this.attachPageSharedContentEvents();
  };

  attachQuillEditorEvents(){
    this.quillEditor.on('text-change', this.pageSharedContent.update.bind(this.pageSharedContent));
    this.quillEditor.on('text-save',   this.pageContent.update.bind(this.pageContent));
  };

  attachPageSharedContentEvents(){
    this.pageSharedContent.on('page_subscribe', (content) => {
      this.quillEditor.enable();
      this.quillEditor.setContents(content);
    });

    this.pageSharedContent.on('page_update', this.quillEditor.updateContents.bind(this.quillEditor));

    this.pageSharedContent.on('expired_token', () => {
        this.quillEditor.disable();
    });
  };
};

export default Editor
