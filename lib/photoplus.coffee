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
      offset               : 5
      imagesToLoad         : 3

    @setCurrentImage = (image) ->
      console.log("currentImage = #{image}")
      @attr.currentImage = image

    @total = ->
      @data['photo_urls'].length

    @setupGallery = ->
      $gallery = @select('gallerySelector')
      $gallery.width(@galleryWidth)

      # FIXME: first image is present; remove it to prevent a duplicate
      $gallery.html('')

      $(@paths[0..4]).each (index, path) =>
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{path}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"
        $gallery.append(html)

      $gallery.find("img:first").addClass('current')

    @imageCount = ->
      "#{@attr.currentImage}/#{@total()}"

    @next = ->
      image = @attr.currentImage
      unless image == @total()
        @setCurrentImage(image += 1)
        @updateCounter(image)
        if @attr.currentImage + 2 == @attr.offset
          @getMoreImages()
        @browse 'right'

    @previous = ->
      image = @attr.currentImage
      unless image == 1
        @setCurrentImage(image -= 1)
        @updateCounter(image)
        @browse 'left'

    @updateCounter = (num) ->
      @select('gallerySelector').find('img.current').removeClass('current')
      @select('gallerySelector').find("a:nth-child(#{num}) img").addClass('current')
      @select('imageCounterSelector').html(@imageCount())

    @getMoreImages = ->
      $gallery = @select('gallerySelector')

      $(@paths[@attr.offset..@attr.offset + @attr.imagesToLoad - 1]).each (index, path) =>
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{path}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"
        $gallery.append(html)

      @attr.offset += @attr.imagesToLoad

    @browse = (direction) ->
      unless @processing
        @processing = true
        options = switch direction
                  when 'left'
                    right: "-=#{@imageWidth}px"
                  else
                    right: "+=#{@imageWidth}px"

        @select('gallerySelector').animate options, 400, =>
          @processing = false

    @after 'initialize', ->
      @data          = @$node.data('photoplus')
      @paths         = @data['photo_urls'] || []
      @href          = @$node.find('a').attr('href')
      @imageWidth    = @$node.width()
      @galleryWidth  = @imageWidth * @total()
      @photoplusId   = @$node.attr('id')
      @resultId      = @$node.closest('.result').attr('id')

      @select('imageCounterSelector').html(@imageCount())

      @$node.closest('.result').on 'mouseenter', =>
        @setupGallery()

      @on 'click',
        rightHotspotSelector: @next
        leftHotspotSelector: @previous

