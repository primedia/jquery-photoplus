describe "photoplus", ['jquery', 'jasmine', 'jasmine-jquery', 'jquery.photoplus'], ($) ->

  beforeEach ->
    loadFixtures "../../../fixtures/photoplus.html"


  describe "initialize", ->
    it "should define the function", ->
      expect($().photoplus).toBeDefined()

  describe "gallery browsing", ->
    beforeEach ->
      $(".photoplus").photoplus()
      $('.result').trigger('mouseenter')

    afterEach ->
      $('').unphotoplus()

    it "should set the image count", ->
      expect( $(".scroll_image_counter").text() ).toEqual("1/4")

    it "should update the image", (done) ->
      imageUrl = "http://image.apartmentguide.com/imgr/0dc84d4fa24ecf6108b58af65ec22aa0/140-105?city=Decatur&property_name=The%20Conservatory%20At%20Druid%20Hills"
      setTimeout =>
        expect( $('img.current').attr('src') ).toEqual(imageUrl)
        done()
      , 2000
      $('.scrollingHotSpotRight').click()

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
