# Kamcaptcha [![Build Status](https://secure.travis-ci.org/zendesk/kamcaptcha.png)](http://travis-ci.org/zendesk/kamcaptcha)

A captcha system that uses less ridiculous images than ReCAPTCHA. Kamcaptcha has two somewhat independent parts to it, a generator for building the word images to present, and then a runtime configuration for checking validity of what gets submitted.

## Generating images

This is something you do locally, probably just once. You need to generate a series of images for your application to serve, using the kamcaptcha command line tool. The tool depends on RMagick being installed, so:

1. `gem install rmagick`
2. kamcaptcha --help

And then generate the images with your preferences. If you specify a salt, make sure to use that same salt when you configure your application runtime. If you do not specify a salt, kamcaptcha will generate you an appropriate one to use, it looks like this:

```sh
$ kamcaptcha  --count 3 /tmp
Generating 3 words into /tmp

  1 /tmp/d519172b9cdfb2de5a5b30cf60836defc9b393f0e38a680937fcd5179467b191.png
  2 /tmp/a235210981703ca66e6d44450c39d42f40ad482bf165401a485b0d3e6c98e3e8.png
  3 /tmp/4ae2941beeea48773243cbf1366520c32dcc7b6375630c0e65bdf313df164ddc.png

Remember to set Kamcaptcha.salt = '58be24c9f6d0293ce2c9316fca1a6ec65d04c9156482b5ae51a267e022ba5a5c' in your application
```

## Runtime configuration

Presumably, Kamcaptcha will be used primarily with Rails, so the following instructions are Rails centric although there's nothing Rails specific about Kamcaptcha.

You need to configure Kamcaptcha in e.g. an initializer:

```ruby
Kamcaptcha.salt = '58be24c9f6d0293ce2c9316fca1a6ec65d04c9156482b5ae51a267e022ba5a5c'
Kamcaptcha.path = File.join(Rails.root, "app", "assets", "images", "kampcaptcha")

# Optionally make use of the included form helper and and validations
ActionController::Base.send(:helper, Kamcaptcha::Helper)
ActionController::Base.send(:include, Kamcaptcha::Validation)
```

You can now use Kamcaptcha in your views:

```ruby
<%= kamcaptcha :label => "Please type in the letters below" %>
```

And in your controllers:

```ruby
return head(:bad_request) unless kamcaptcha_validates?
```

You can write your own helper and controller logic easily, take a look at the source.

## Copyright and license

Copyright 2013 Zendesk

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
