## jquery-photoplus

#### Setup

```
# update gems
bundle install

# ensure that you have PhantomJS installed so that Jasmine can perform the tests without a browser
brew install phantomjs

# make sure you have these, too, so that the default rake task can install packages and compile javascript
npm install -g bower coffee-script

# satisfy dependencies and run the test suite
rake
```
