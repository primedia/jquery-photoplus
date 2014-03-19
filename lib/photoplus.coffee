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
      @attr.currentImage = 0 if @total() == 0
      @attr.currentImage = image

    @total = ->
      @paths.length

    @setupGallery = ->
      @select('imageCounterSelector').html(@imageCount())
      $gallery = @select('gallerySelector')
      $gallery.width(@total * @imageWidth);

      $(@paths).each (index, path) =>
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{path}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"
        $gallery.append(html)

    @imageCount = ->
      "#{@current()}/#{@total()}"

    @next = ->
      image = @current()
      unless image == @total()
        @browse 'right', =>
          @current(image+1)
          @select('imageCounterSelector').html(@imageCount())

    @previous = ->
      image = @current()
      unless image == 1
        @browse 'left', =>
          @current(image-1)
          @select('imageCounterSelector').html(@imageCount())

    @browse = (direction, cb) ->
      unless @processing
        @processing = true
        options = switch direction
                  when 'left'
                    right: "-=#{@imageWidth}px"
                  else
                    right: "+=#{@imageWidth}px"

        @select('gallerySelector').animate options, 400, =>
          @processing = false
          cb()

    @after 'initialize', ->
      @data          = @$node.data('photoplus')
      @paths         = @data['photo_urls'] || []
      @href          = @$node.find('a').attr('href')
      @imageWidth    = @$node.width()
      @photoplusId   = @$node.attr('id')
      @resultId      = @$node.closest('.result').attr('id')


      @$node.closest('.result').on 'mouseenter', =>
        @setupGallery()

      @on 'click',
        rightHotspotSelector: @next
        leftHotspotSelector: @previous

