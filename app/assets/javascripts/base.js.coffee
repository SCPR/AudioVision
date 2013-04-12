window.audiovision ?= {}

# stub console.log() for IE 8
if !window.console
    class window.console
        @log: ->
