define ['jquery', './photoplus'], ($, Photoplus) ->

  $.fn.photoplus = ->
    $(this).each ->
      Photoplus.attachTo(this)

  $.fn.unphotoplus = ->
    Photoplus.teardownAll()
