describe "photoplus", ['jquery', 'jasmine', 'jasmine-jquery', 'jquery.photoplus'], ($) ->

  beforeEach ->
    loadFixtures "../../../fixtures/photoplus.html"

  media = {
    photos: [
      { path: "/imgr/b2a6c1289572c74ce779a2885c7e3861/" }
      { path: "/imgr/0dc84d4fa24ecf6108b58af65ec22aa0/" }
      { path: "/imgr/6df348165582a5b57cfbad37aa2c0d4c/" }
      { path: "/imgr/a6b23983bfadb3c01a1537ff1db25a52/" }
    ]
    floorplans: []
  }

  describe "initialize", ->
    it "should define the function", ->
      expect($().photoplus).toBeDefined()

  describe "gallery browsing", ->
    beforeEach ->
      @node = $(".photoplus")
      @node.photoplus()
      $('.result').trigger('mouseenter')

    afterEach ->
      $('').unphotoplus()

    it "should set the image count", ->
      expect( $(".scroll_image_counter").text() ).toEqual("1/4")

    it "should trigger request for media", ->
      spyOnEvent(@node, 'uiWantsListingMedia')
      $('.scrollingHotSpotRight').click()
      expect('uiWantsListingMedia').toHaveBeenTriggeredOnAndWith(@node, { listingId: '6693' })

    it "should update the image", (done) ->
      imageUrl = "http://image.apartmentguide.com/imgr/0dc84d4fa24ecf6108b58af65ec22aa0/180-180"
      setTimeout =>
        expect( $('img.current').attr('src') ).toEqual(imageUrl)
        done()
      , 2000
      $('.scrollingHotSpotRight').click()
      @node.trigger('dataListingMediaReady', media)

    it "should update the counter", (done) ->
      setTimeout =>
        expect( $(".scroll_image_counter").text() ).toEqual("2/4")
        done()
      , 1000
      $('.scrollingHotSpotRight').click()

    it "should continue from the beginning", (done) ->
      pending()
      clicks = 0
      interval = (setInterval =>
        clicks++
        $('.scrollingHotSpotRight').click()
        if clicks == 5
          clearInterval(interval)
          done()
      , 500)
      expect( $(".scroll_image_counter").text() ).toEqual("1/4")
      # This actually is not a feature [yet]

    it "should loop back to the end", (done) ->
      pending()
      setTimeout done, 1000
      $('.scrollingHotSpotLeft').click()
      expect( $(".scroll_image_counter").text() ).toEqual("4/4")
      # This actually is not a feature [yet]

  describe "custom count format", ->
    beforeEach ->
      $(".photoplus").photoplus({ imageCountFormat: ':current of :total' })

    afterEach ->
      $('').unphotoplus()

    it "should set the image count", ->
      expect( $(".scroll_image_counter").text() ).toEqual("1 of 4")
