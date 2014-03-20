require.config({
  shim: {
    "jasmine" : {
      exports: 'jasmine'
    },
    "jasmine-jquery" : ["jasmine"]
  },
  paths: {
    "jquery" : "vendor/bower/jquery/jquery",
    "flight" : "vendor/bower/flight",
    "jasmine" : "vendor/bower/jasmine/lib/jasmine-core/jasmine",
    "jasmine-jquery" : "vendor/jasmine-jquery"
  }
});
