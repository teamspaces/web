import $ from 'jquery'
import Ps from 'perfect-scrollbar'
import tippy from 'tippy.js/dist/tippy'

// TODO Scroll to item when using arrow keys
class InstantSearch {

  /*
    Constructor options:
    {
      input: '.selector',
      clearButton: '.selector',
      resultsContainer: '.selector',
      showHints: true,
      useFocusShortcut: true
    }
  */
  constructor (options) {
    this.options = options
    this.input = null
    this.clearButton = null
    this.resultsContainer = null
    this.resultsContainerResults = null
    this.resultsContainerHints = null
    this.resultsContainerSpinner = null
    this.showHints = options.showHints || false
    this.useFocusShortcut = options.useFocusShortcut || false
    this.isCtrlDown = false
    this.isJDown = false
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
    // Store the elements that were passed in as options
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
        html: '&uarr;&darr; to select, <b>Enter</b> to open, <b>Escape</b> to close'
      })

      this.resultsContainer.append(this.resultsContainerHints)
    }

    // Create a spinner
    this.resultsContainerSpinner = $('<div>', {class: 'instant-search__spinner', html: '<div class="instant-search__spinner-bounce-1"></div><div class="instant-search__spinner-bounce-2"></div>'})
    this.resultsContainer.append(this.resultsContainerSpinner)

    // Custom scrollbar
    Ps.initialize( this.resultsContainerResults.get(0) )
  }

  addListeners () {
    this.input.on('input.instantsearch', this.onInput.bind(this))
    this.clearButton.on('click.instantsearch', this.onClearClick.bind(this))
    this.resultsContainer.on('mouseenter.instantsearch', '.instant-search__item', this.onMouseEnterItem.bind(this))
    $(document).on('keydown.instantsearch', this.onDocumentKeydown.bind(this))
    $(document).on('keyup.instantsearch', this.onDocumentKeyup.bind(this))
  }

  removeListeners () {
    this.input.off('input.instantsearch')
    this.clearButton.off('click.instantsearch')
    this.resultsContainer.off('mouseenter.instantsearch', '.instant-search__item')
    $(document).off('keydown.instantsearch')
    $(document).off('keyup.instantsearch')
  }

  onInput (e) {
    // Save the search query
    const query = $(e.currentTarget).val()

    // Check if the input is empty
    if(query.length > 0) {
      // Show results container and clear button
      this.showResults()

      // Show the spinner
      this.showSpinner()

      // Show a searching message if there are no results currently visible (from a previous query)
      if(this.resultsContainerResults.find('.instant-search__item').length === 0) {
        this.addResultsMessage('Searching...')
      }

      // Clear any existing timer
      this.clearSearchTimer()

      // Delay the search to throttle requests
      this.searchTimer = window.setTimeout(this.search.bind(this, query), 250)

    // Hide results if the query is empty
    } else {
      this.hideResults()
    }
  }

  onClearClick (e) {
    this.clearInput()
    this.hideResults()
  }

  onMouseEnterItem (e) {
    // Get the index of current element
    const index = $(e.currentTarget).index()

    // Update selected index
    this.selectItem(index)
  }

  onDocumentKeydown (e) {
    // Store that ctrl or j is down
    if(e.keyCode === 17) {
      this.isCtrlDown = true
    } else if(e.keyCode === 74) {
      this.isJDown = true
    }

    // Check if we want to use a keyboard shortcut to give the input focus
    if(this.useFocusShortcut && this.isCtrlDown && this.isJDown) {
      this.input.focus()
    }

    // We're only interested in these events when the results are visible
    if(this.isVisible) {
      // Escape clears the input
      if(e.keyCode === 27) {
        this.clearInput()
        this.hideResults()
      }

      // Up moves to the previous item
      else if(e.keyCode === 38) {
        e.preventDefault()
        this.selectPreviousItem()
      }

      // Down moves to the next item
      else if(e.keyCode === 40) {
        e.preventDefault()
        this.selectNextItem()
      }

      // Enter opens the selected item
      else if(e.keyCode === 13) {
        this.openCurrentItem()
      }

      // Tab blurs input but prevents default functionality
      else if(e.keyCode === 9) {
        e.preventDefault()
        this.input.blur()
      }
    }
  }

  onDocumentKeyup (e) {
    // Store that ctrl or j is no longer down
    if(e.keyCode === 17) {
      this.isCtrlDown = false
    } else if(e.keyCode === 74) {
      this.isJDown = false
    }
  }

  onSearchDone (response) {
    this.hideSpinner()
    this.clearResults()

    // Add new items
    if(response.length > 0) {
      // Render an element for each item
      response.map(this.renderItem, this)

      // Select the first item in the results
      this.selectItem(0)

    // Show a message if the response was empty
    } else {
      this.addResultsMessage('No results found for <b>' + this.query + '</b>')
    }
  }

  onSearchFail (request) {
    // Ignore the error if it's a request we aborted
    if(request.status === 0) {
      return
    }

    this.hideSpinner()
    this.clearResults()
    this.addResultsMessage('Something went wrong. Please try again later.')
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

  renderItem (item) {
    // Create element
    const element = `
      <li class="instant-search__item">
        <a href="${ item.url }" tabindex="-1">
          <div class="instant-search__cover" style="background-image: url(https://images.unsplash.com/photo-1497215457980-d57c69aee12d?dpr=2&auto=format&fit=crop&w=1500&h=1000&q=80&cs=tinysrgb&crop=);"></div>
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
    // Get items
    const items = this.resultsContainerResults.find('.instant-search__item')

    // Check if we have any visible results
    if(items.length > 0) {

      // Ensure that the index is within bounds
      if(index < 0) {
        index = 0
      } else if(index > items.length - 1) {
        index = items.length - 1
      }

      // Store new index
      this.currentItemIndex = index

      // Remove selected classes from all results
      items.removeClass('instant-search__selected')

      // Select the new item
      items.eq(this.currentItemIndex).addClass('instant-search__selected')
    }

  }

  openCurrentItem () {
    // Search for a selected item
    const selected = this.resultsContainerResults.find('.instant-search__selected')

    // Check if we found a selected item
    if(selected.length > 0) {
      // Get the url
      const url = selected.find('a').attr('href')

      // Redirect to the url
      window.location.href = url
    }

  }

  showSpinner () {
    this.resultsContainerSpinner.addClass('instant-search__visible')
  }

  hideSpinner () {
    this.resultsContainerSpinner.removeClass('instant-search__visible')
  }

  showResults () {
    this.isVisible = true
    this.resultsContainer.addClass('instant-search__visible')
    this.clearButton.addClass('instant-search__visible')
    $('body').addClass('body--no-scroll')
  }

  hideResults () {
    this.isVisible = false
    this.resultsContainer.removeClass('instant-search__visible')
    this.clearButton.removeClass('instant-search__visible')
    $('body').removeClass('body--no-scroll')

    // Reset index
    this.currentItemIndex = 0

    // Clear any existing search timer
    this.clearSearchTimer()

    // Clear results
    this.clearResults()
  }

  addResultsMessage (message) {
    this.resultsContainerResults.html('<li class="instant-search__message">' + message + '</li>')
  }

  clearResults () {
    this.resultsContainerResults.empty()
    this.searchResults = []
  }

  clearSearchTimer () {
    if(this.searchTimer) {
      window.clearTimeout(this.searchTimer)
    }
  }

  clearInput () {
    // Empty input
    this.input.val('').focus()
  }

  destroy () {
    this.removeListeners()

    this.input = null
    this.clearButton = null
    this.resultsContainer = null
    this.searchXhr = null
    this.resultsContainerSpinner.remove()
    this.resultsContainerSpinner = null
    if(this.resultsContainerHints) this.resultsContainerHints.remove()
    this.resultsContainerHints = null
  }
}

export default InstantSearch
