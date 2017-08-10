import $ from 'jquery'

// TODO If results higher than viewport, fixed hints
class InstantSearch {

  /*
    Constructor options:
    {
      input: '.selector',
      clearButton: '.selector',
      resultsContainer: '.selector',
      showHints: true
    }
  */
  constructor (options) {
    this.options = options
    this.input = null
    this.clearButton = null
    this.resultsContainer = null
    this.resultsContainerResults = null
    this.resultsContainerHints = null
    this.showHints = options.showHints || false
    this.isVisible = false
    this.query = ''
    this.currentItemIndex = 0
    this.searchResults = []
    this.searchXhr = null
    this.searchTimer = null

    // Wait until the dom has loaded
    $(this.onDomLoaded.bind(this))
  }

  onDomLoaded () {
    // Save the elements that were passed in as options
    this.input = $( this.options.input )
    this.clearButton = $( this.options.clearButton )
    this.resultsContainer = $( this.options.resultsContainer )

    // Render component
    this.render()

    // Add listeners
    this.addListeners()
  }

  render () {
    // Create an inner element for the search results
    this.resultsContainerResults = $('<ul>', {class: 'instant-search__results'})
    this.resultsContainer.append(this.resultsContainerResults)

    // Create hints
    if(this.showHints) {
      this.resultsContainerHints = $('<div>', {
        class: 'instant-search__hints',
        html: '&uarr; &darr; to select, <b>Enter</b> to open'
      })

      this.resultsContainer.append(this.resultsContainerHints)
    }
  }

  addListeners () {
    this.input.on('input', this.onInput.bind(this))
    this.clearButton.on('click', this.onClearClick.bind(this))
    $(document).on('keydown', this.onDocumentKeydown.bind(this))
  }

  removeListeners () {
    // TODO Test off with .bind(this), anonymous?
  }

  onInput (e) {
    // Save the search query
    const query = $(e.currentTarget).val()

    // Show the spinner
    this.showSpinner()

    // Clear any existing search timer
    if(this.searchTimer) {
      window.clearTimeout(this.searchTimer)
    }

    // Delay the search to throttle requests
    this.searchTimer = window.setTimeout(this.search.bind(this, query), 250)
  }

  onClearClick () {
    this.clearInput()
  }

  onDocumentKeydown (e) {
    // Ignore the event if the instant search results aren't visible
    if(!this.isVisible) {
      return
    }

    // Escape clears the input
    // TODO Check if programmatic change triggers input event
    if(e.keyCode === 27) {
      this.clearInput()
    }

    // Up moves to the previous item
    else if(e.keyCode === 38) {
      this.selectPreviousItem()
    }

    // Down moves to the next item
    else if(e.keyCode === 40) {
      this.selectNextItem()
    }

    // Enter opens the selected item
    else if(e.keyCode === 13) {
      this.openCurrentItem()
    }
  }

  onSearchDone (response) { console.log('done', response)
    this.hideSpinner()
    this.clearResults()

    // Show results
    if(response.length > 0) {
      // Render an element for each element in the response
      response.map(this.renderItem, this)

      // Select the first item in the results
      this.selectItem(0)
    } else {
      this.resultsContainerResults.append('<li class="instant-search__empty">No results found for <b>' + this.query + '</b></li>')
    }
  }

  onSearchFail (request) {
    // Ignore the error if it's a request we aborted
    if(request.status === 0) {
      return
    }

    this.hideSpinner()
    this.clearResults()

    this.resultsContainerResults.append('<li class="instant-search__error">Something went wrong. Please try again later.</li>')
  }

  search (query) {
    this.query = query

    // Abort any pending reqests to ensure that the latest query gets rendered last, e.g. when typing fast
    if(this.searchXhr) {
      this.searchXhr.abort()
    }

    // Fetch search results
    this.searchXhr = $.ajax({
      cache: false,
      context: this,
      data: { q: this.query },
      dataType: 'json',
      method: 'GET',
      url: '/page/search.json'
    })
    .done( this.onSearchDone )
    .fail( this.onSearchFail )
  }

  clearInput () {
    this.clearResults()
    this.currentItemIndex = 0
  }

  clearResults () {
    this.resultsContainerResults.empty()
    this.searchResults = []
  }

  renderItem (item) {
    // Create element
    const element = `
      <li>
        <a href="${ item.url }">
          <img src="https://images.unsplash.com/photo-1497215457980-d57c69aee12d?dpr=2&auto=format&fit=crop&w=1500&h=1000&q=80&cs=tinysrgb&crop=" alt="${ item.title }">
          <h3>${ item.title }</h3>
          <p class="instant-search__space">${ item.space.name }</p>
          <p class="instant-search__excerpt">${ item.contents }</p>
        </a>
      </li>
    `

    // Add the new element to the dom
    this.resultsContainerResults.append(element)
  }

  selectNextItem () {
    this.selectItem( this.currentItemIndex + 1 )
  }

  selectPreviousItem () {
    this.selectItem( this.currentItemIndex - 1 )
  }

  selectItem (index) {
    // Ensure that the index is within bounds
    if(index < 0) {
      index = 0
    } else if(index > this.searchResults.length - 1) {
      index = this.searchResults.length - 1
    }

    this.currentItemIndex = index

    // Remove selected classes from all results
    this.resultsContainerResults.find('li').removeClass('instant-search__selected')

    // Select the new item
    // TODO Check if empty first
    this.resultsContainerResults.find('li').get(this.currentItemIndex).addClass('instant-search__selected')
  }

  openCurrentItem () {
    // Find the selected item
    const selected = this.resultsContainerResults.find('.instant-search__selected')

    // Get the url
    const url = selected.find('a').attr('href')

    // Redirect to the url
    window.location.href = url
  }

  showSpinner () {

  }

  hideSpinner () {

  }

  destroy () {
    this.removeListeners()

    this.input = null
    this.clearButton = null
    this.resultsContainer = null
    this.searchXhr = null
  }
}

export default InstantSearch
