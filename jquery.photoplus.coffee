define ['jquery', 'lib/photoplus'], ($, Photoplus) ->

  $.fn.photoplus = ->
    $(this).each ->
      Photoplus.attachTo(this)
