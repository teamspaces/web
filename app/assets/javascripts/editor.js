import QuillEditor from './quill_editor'
import PageSharedContent from './page/shared_content'
import PageContent from './page/content'

class Editor {

  constructor({ attachTo, options }) {
    this.pageContent = new PageContent(options);
    this.pageSharedContent = new PageSharedContent(options);

    const onSaveTextChange   = this.pageSharedContent.update.bind(this.pageSharedContent);
    const onSaveCompleteText = this.pageContent.update.bind(this.pageContent);

    this.quillEditor = new QuillEditor({ attachTo: attachTo,
                                         onSaveTextChange: onSaveTextChange,
                                         onSaveCompleteText: onSaveCompleteText });

    this.pageSharedContent.onUpdate(this.quillEditor.updateContents.bind(this.quillEditor));

    this.init();
  };

  init(){
    this.pageSharedContent.onPageSubscribe((content) => {
      this.quillEditor.enable();
      this.quillEditor.setContents(content);
    });
  };
};

export default Editor
