// import * as log from 'loglevel'

import QuillEditor from './quill_editor'
import PageSharedDB from './page/page_shared_db'
import PageDB from './page/page_db'

const logger = log.getLogger('editor')

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
    this.quillEditor.on('text-change', this.pageSharedDB.update.bind(this.pageSharedDB))
    this.quillEditor.on('text-change', () => this.statusMessage.update("Saving..."))
    this.quillEditor.on('text-save', this.pageDB.update.bind(this.pageDB))
  }

  attachPageDBEvents(){ // web_server events
    this.pageDB.on('saved', (response) => this.statusMessage.update("Your changes have been saved."))
    this.pageDB.on('error', (error) => {
      logger.error(error)
      Raven.captureException(error)
      this.disableEditor();
    })
  }

  attachPageSharedDBEvents(){ // collab_server events
    this.pageSharedDB.on('subscribe', (content) => {
      this.quillEditor.setContents(content)
    })

    this.pageSharedDB.on('update', this.quillEditor.updateContents.bind(this.quillEditor))
    this.pageSharedDB.on('error', (error) => {
      logger.error(error)
      Raven.captureException(error)
      this.disableEditor();
    })

    this.pageSharedDB.on('connect', () => this.enableEditor())
    this.pageSharedDB.on('disconnect', () => this.disableEditor())
  }

  enableEditor(){
    logger.debug("enabling editor")
    this.quillEditor.enable()
  }

  disableEditor(){
    logger.debug("disabling editor")
    this.quillEditor.disable()
  }
}

export default Editor
