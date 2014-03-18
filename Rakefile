begin
  require 'yaml'
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

task :default do
  Rake::Task["install"].invoke
  Rake::Task["brew"].invoke
  Rake::Task["jasmine:ci"].invoke
end

desc "Compile coffeescript files"
task :brew do
  puts "Waiting for coffee to brew..."
  system "coffee --compile --bare ."
  puts "Scripts compiled."
end

desc "Satisfy dependencies"
task :install do
  system "bower install"
  system "cp jquery.photoplus.js spec/javascripts/jquery.photoplus.js"
end
