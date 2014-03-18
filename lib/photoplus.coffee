define [
  'jquery',
  'flight/lib/component'
], (
  $,
  defineComponent
) ->

  defineComponent ->
    @defaultAttrs
      gallerySelector      : ".scrollableArea",
      leftHotspotSelector  : ".scrollingHotSpotLeft",
      rightHotspotSelector : ".scrollingHotSpotRight"
      imageCounterSelector : ".scroll_image_counter"
      processing           : false
      currentImage         : 1

    @current = (image = @attr.currentImage) ->
      @currentImage ||= image

    @total = ->
      @paths.length

    @setupGallery = ->
      $gallery = @select('gallerySelector')
      $(@paths).each ->
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{this}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"
        console.log(html)
        $gallery.append(html)

    @imageCount = ->
      "#{@current}/#{@total}"

    @next = ->
      image = @current
      unless image == @total
        @browse('right')
        @current(image+1)
        @select('imageCounterSelector').html(@imageCount())

    @previous = ->
      image = @current
      unless image == 1
        @browse('left')
        @current(image-1)
        @select('imageCounterSelector').html(@imageCount())

    @browse = (direction) ->
      options = switch direction
                when 'left'
                 right: "-=#{@attr.image_width}px"
                else
                  right: "+=#{@attr.image_width}px"
      @attr.processing = true
      @select('gallerySelector')
      .animate options, 400, ->
        @attr.processing = false;

    @on @leftHotspotSelector, 'click', @previous
    @on @rightHotspotSelector, 'click', @next

    @after 'initialize', ->
      @data          = @$node.data('photoplus')
      @paths         = @data['photo_urls'] || []
      @href          = @$node.find('a').attr('href')
      @imageWidth    = @$node.width()
      @photoplusId   = @$node.attr('id')
      @resultId      = @$node.closest('.result').attr('id')
      @$node.closest('.result').on 'mouseenter', =>
        @setupGallery()

