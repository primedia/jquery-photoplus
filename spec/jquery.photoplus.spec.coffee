describe "photoplus", ['jquery', 'jasmine', 'jasmine-jquery', 'photoplus'], ($) ->
  # $ = null

  beforeEach ->
    loadFixtures "../../../fixtures/photoplus.html"

  describe "initialize", ->
    it "should define the function", ->
      expect($().photoplus).toBeDefined()
