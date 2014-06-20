define [
  'jquery',
  'flight/lib/component',
  'components/data/with_listing_media'
], (
  $,
  defineComponent,
  withListingMedia
) ->

  photoPlus = ->
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

    @dataSelector = ->
      dataSelectorId = '#photo_plus_result_' + @listingId 
      $(dataSelectorId)

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

      if @includeFloorplans 
       photos = media.photos.concat(media.floorplans)
      else
       photos = media.photos

      # append all photos, but don't append the first photo again
      $(photos[1..]).each (index, photo) => 
        html = "<a href='#{@href}'>"
        html += "<img src='http://image.apartmentguide.com#{photo.path}' "
        html += "width='#{@imageWidth}px' height='105px'></a>"
        @gallery().append(html)

      @gallery().find("img:first").addClass('current')

    @galleryPhotoCount = ->
      @gallery().find('a').length

    @galleryPopulated = ->
      @galleryPhotoCount() > 1

    @imageCount = ->
      "#{@current()}/#{@total()}"

    @next = ->
      @getPhotoPlusMedia(@listingId) unless @galleryPopulated()

      image = @current()
      unless image == @total()
        @current(image += 1)
        @updateCounter(image)
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

      @on 'infoWindowDataAvailable',
        @select('imageCounterSelector').html(@imageCount())

  defineComponent photoPlus, withListingMedia
