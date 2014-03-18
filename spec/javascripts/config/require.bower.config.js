require.config({
  shim: {
    "jasmine" : {
      exports: 'jasmine'
    },
    "jasmine-jquery" : ["jasmine"]
  },
  paths: {
    "jquery" : "vendor/bower/jquery/jquery",
    "jasmine" : "vendor/bower/jasmine/lib/jasmine-core/jasmine",
    "jasmine-jquery" : "vendor/jasmine-jquery",
    "jasmine-flight" : "vendor/jasmine-flight",
    "photoplus" : "jquery.photoplus"
  }
});
