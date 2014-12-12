define [
  'jquery'
  'flight/lib/component'
], (
  $,
  defineComponent
) ->

  photoPlus = ->
    @defaultAttrs
      gallerySelector      : ".scrollableArea",
      leftHotspotSelector  : ".scrollingHotSpotLeft",
      rightHotspotSelector : ".scrollingHotSpotRight"
      imageCounterSelector : ".scroll_image_counter"
      processing           : false
      currentImage         : 1
      resultSelector       : '#photo_plus_result_'
      pinSelector          : '#photo_plus_pin_'
      offset               : 5
      imagesToLoad         : 3
      imageCountFormat     : ':current/:total'
      dimensions           : '180-180'

    @current = (image = @attr.currentImage) ->
      @attr.currentImage = 0 if @total() == 0
      @attr.currentImage = image

    @dataSelector = ->
      resultSelector = $( @attr.resultSelector + @listingId )
      pintSelector   = @attr.pinSelector + @listingId
      if resultSelector && resultSelector.length > 0 then resultSelector else $(pintSelector)

    @total = ->
      @dataSelector().data('num_media')

    @includeFloorplans = ->
      result = @dataSelector().data('floorplans_flag')
      Boolean(result)

    @gallery = ->
      @select('gallerySelector')

    # append remaining photos to the current listing's photo gallery
    # but only if the gallery only has the first photo,
    # which is already visible
    @populateGallery = (media) ->
      @gallery().width(@galleryWidth)

      return if @galleryPopulated()

      @photos = media.photos.concat(media.floorplans) if @includeFloorplans

      # append all photos, but don't append the first photo again
      $(@photos[1..4]).each (index, photo) =>
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{@addSize(photo.path)}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"

        @gallery().append(html)

      @gallery().find("img:first").addClass('current')

    @addSize = (path) ->
      pathWithSlash = if path.substr(-1) == '/' then path else "#{path}/"
      "#{pathWithSlash}#{@attr.dimensions}"

    @galleryPhotoCount = ->
      @gallery().find('a').length

    @galleryPopulated = ->
      @galleryPhotoCount() > 1

    @imageCount = ->
      @attr.imageCountFormat.replace(":current", @current()).replace(":total", @total())

    @next = ->
      unless @galleryPopulated()
        @trigger 'uiWantsListingMedia', { listingId: @listingId }

      image = @current()
      unless image == @total()
        @current(image += 1)
        @updateCounter(image)
        # when I get to the (offset -2)th image, get more images before user gets to the end of the set of images already fetched
        if @attr.currentImage + 2 == @attr.offset
          @getMoreImages()
        @browse 'right'

    @previous = ->
      image = @current()
      unless image == 1
        @current(image -= 1)
        @updateCounter(image)
        @browse 'left'

    @updateCounter = (num) ->
      @select('gallerySelector').find('img.current').removeClass('current')
      @select('gallerySelector').find("a:nth-child(#{num}) img").addClass('current')
      @select('imageCounterSelector').html(@imageCount())

    @getMoreImages = ->
      $(@photos[@attr.offset..@attr.offset + @attr.imagesToLoad - 1]).each (index, photo) =>
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{@addSize(photo.path)}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"

        @gallery().append(html)

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
      @href          = @$node.find('a').attr('href')
      @imageWidth    = @$node.width()
      @listingId     = @$node.closest('.result').attr('id').split("_")[1]
      @galleryWidth  = @imageWidth * @total()

      @select('imageCounterSelector').html(@imageCount())

      @on 'click',
        rightHotspotSelector: @next
        leftHotspotSelector: @previous

      @on 'dataListingMediaReady', (event, data) ->
        @populateGallery(data)

  defineComponent photoPlus
