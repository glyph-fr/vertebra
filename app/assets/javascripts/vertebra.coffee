# Global Vertebra namespace
@Vertebra = {}

# Allows assigning unique ids to views
lastUniqueId = 0
uniqueId = (prefix) ->
  [prefix, ++lastUniqueId].join('-')

# Regex to split delegated events string
delegateEventSplitter = /^(\S+)\s*(.*)$/

@camelize = (str) ->
  str.replace(/(^|[-_])(.)/g, (match) -> return match.toUpperCase()).replace(/[-_]/g, '')

@trim = (str) ->
  str.replace(/^\s+|\s+$/g, '')

_now = Date.now || -> new Date().getTime()

# Throttle function borrowed from underscore.js
@throttle = (func, wait, options) ->
  previous = 0
  options ?= {}

  later = ->
    previous = if options.leading == false then 0 else _now()
    timeout = null
    result = func.apply(context, args)
    if !timeout
      context = args = null
    return

  ->
    now = _now()
    previous = now if !previous and options.leading == false
    remaining = wait - (now - previous)
    context = this
    args = arguments

    if remaining <= 0 or remaining > wait
      if timeout
        clearTimeout(timeout)
        timeout = null
      previous = now
      result = func.apply(context, args)
      if !timeout
        context = args = null
    else if !timeout and options.trailing != false
      timeout = setTimeout(later, remaining)

    result


# Minimalist Backbon.View with support for view element, this.$ and delegated
# events on initialization.
#
# Only depends on jQuery, and not underscore.js
class Vertebra.View
  $: (selector) ->
    @$el.find(selector)

  constructor: (options) ->
    @setElement(options.el) if options.el
    @_eventListeners = {}
    @_listeningTo = {}
    @cid = uniqueId('view')
    @initialize?.apply(this, arguments)

  setElement: (el) ->
    @$el = if el instanceof $ then el else $(el)
    @el = @$el[0]
    @delegateEvents()

  delegateEvents: ->
    return unless @events
    @_undelegateEvents()

    for key, method of @events
      method = @[method]
      continue unless method
      match = key.match(delegateEventSplitter)
      @delegate(match[1], match[2], $.proxy(method, this))

  delegate: (eventName, selector, listener) ->
    @$el?.on(eventName + '.delegateEvents' + @cid, selector, listener)

  _undelegateEvents: ->
    @$el?.off('.delegateEvents' + @cid)

  listenTo: (object, eventName, listener) ->
    @_listeningTo[object.cid] ?= {}
    @_listeningTo[object.cid][eventName] ?= []
    @_listeningTo[object.cid][eventName].push(listener)

    object.on(eventName, (=> listener.apply(this, arguments)))

  on: (eventName, listener) ->
    @_eventListeners[eventName] ?= []
    @_eventListeners[eventName].push(listener)

  off: (eventName, listener) ->
    return unless (listeners = @_eventListeners[eventName])

    if listener
      listeners.splice(index, 1) for index of listeners when listeners[index] is listener
    else
      @_eventListeners[eventName] = []

  trigger: (eventName, args...) ->
    if (listeners = @_eventListeners[eventName])
      listener.apply(this, args) for listener in listeners

  stopListeningTo: (object, eventName, listener) ->
    if (listenersHash = @_listeningTo[object.cid]) and (listeners = listenersHash[eventName])
      object.off(eventName, listener) for listener in listeners

  stopListening: ->
    return unless @_listeningTo

    for object, events of @_listeningTo
      for eventName, listeners of events
        @stopListeningTo(object, eventName, listener)

  destroy: ->
    @stopListening()


