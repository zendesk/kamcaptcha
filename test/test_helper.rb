require "bundler"

require "minitest/spec"
require "minitest/mock"
require "minitest/autorun"

Bundler.require

require "RMagick"
require "debugger" unless ENV["TRAVIS"]

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require "kamcaptcha"
require "kamcaptcha/helper"
require "kamcaptcha/validation"
require "kamcaptcha/generator"

Kamcaptcha.salt = Time.now.to_f.to_s
