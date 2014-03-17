// Generated by CoffeeScript 1.7.1
describe("photoplus", ['jquery', 'jasmine', 'jasmine-jquery', 'photoplus'], function($) {
  beforeEach(function() {
    return loadFixtures("../../../fixtures/photoplus.html");
  });
  describe("initialize", function() {
    return it("should define the function", function() {
      return expect($().photoplus).toBeDefined();
    });
  });
  return describe("gallery browsing", function() {
    beforeEach(function() {
      $(".photoplus").photoplus();
      return $('.result').trigger('mouseenter');
    });
    it("should set the image count", function() {
      return expect($(".scroll_image_counter").text()).toEqual("1/4");
    });
    it("should update the image", function(done) {
      var imageUrl;
      imageUrl = "http://image.apartmentguide.com/imgr/0dc84d4fa24ecf6108b58af65ec22aa0/140-105?city=Decatur&property_name=The%20Conservatory%20At%20Druid%20Hills";
      setTimeout((function(_this) {
        return function() {
          return done();
        };
      })(this), 1000);
      $('.scrollingHotSpotRight').click();
      return expect($('img:first:visible').attr('src')).toEqual(imageUrl);
    });
    it("should update the counter", function(done) {
      setTimeout((function(_this) {
        return function() {
          expect($(".scroll_image_counter").text()).toEqual("2/4");
          return done();
        };
      })(this), 1000);
      return $('.scrollingHotSpotRight').click();
    });
    it("should continue from the beginning", function(done) {
      var clicks, interval;
      pending();
      clicks = 0;
      interval = setInterval((function(_this) {
        return function() {
          clicks++;
          $('.scrollingHotSpotRight').click();
          if (clicks === 5) {
            clearInterval(interval);
            return done();
          }
        };
      })(this), 500);
      return expect($(".scroll_image_counter").text()).toEqual("1/4");
    });
    return it("should loop back to the end", function(done) {
      pending();
      setTimeout(done, 1000);
      $('.scrollingHotSpotLeft').click();
      return expect($(".scroll_image_counter").text()).toEqual("4/4");
    });
  });
});