import QuillEditor from './quill_editor'
import PageSharedDB from './page/page_shared_db'
import PageDB from './page/page_db'

class Editor {

  constructor({ attachTo, statusMessage, options }) {
    this.statusMessage = statusMessage

    this.pageDB       = new PageDB(options) // web_server
    this.pageSharedDB = new PageSharedDB(options) // collab_server
    this.quillEditor  = new QuillEditor({ attachTo: attachTo })

    this.attachQuillEditorEvents()
    this.attachPageDBEvents()
    this.attachPageSharedDBEvents()
  }

  attachQuillEditorEvents(){
    log.debug('[Editor] attaching quill events')
    this.quillEditor.on('text-change', this.pageSharedDB.update.bind(this.pageSharedDB))
    this.quillEditor.on('text-change', () => this.statusMessage.update("Saving..."))
    this.quillEditor.on('text-save', this.pageDB.update.bind(this.pageDB))
  }

  // Internal: Responsible for frequently saving page contents to database.
  attachPageDBEvents(){
    log.debug('[Editor] attaching Page events')

    this.pageDB.on('saved', (response) => this.statusMessage.update("Your changes have been saved."))
    this.pageDB.on('error', (error) => {
      this.statusMessage.update("We are currently unable to save your changes.")
      log.error(error)
      Raven.captureException(error)
      this.disableEditor();
    })
  }

  // Internal: Responsible for updates from collaboration server.
  attachPageSharedDBEvents(){
    this.pageSharedDB.on('subscribe', (content) => {
      this.quillEditor.setContents(content)
    })

    this.pageSharedDB.on('update', this.quillEditor.updateContents.bind(this.quillEditor))
    this.pageSharedDB.on('error', (error) => {
      log.error(error)
      Raven.captureException(error)
      this.disableEditor();
    })

    this.pageSharedDB.on('connect', () => {
      this.statusMessage.clear()
      this.enableEditor()
    })
    this.pageSharedDB.on('disconnect', () => {
      this.statusMessage.update("You are currently offline.")
      this.disableEditor()
    })
  }

  enableEditor(){
    log.debug("[Editor] enabling")
    this.quillEditor.enable()
  }

  disableEditor(){
    log.debug("[Editor] disabling")
    this.quillEditor.disable()
  }
}

export default Editor
