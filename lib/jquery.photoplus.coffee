define ['jquery', './photoplus'], ($, Photoplus) ->

  $.fn.photoplus = (data) ->
    $(this).each ->
      Photoplus.attachTo(this, data)

  $.fn.unphotoplus = ->
    Photoplus.teardownAll()
