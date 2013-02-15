Gem::Specification.new "kamcaptcha", "1.0.0" do |s|
  s.summary     = "A captcha image generator that's a little less retarded"
  s.description = "Helps humankind with simpler captchas"
  s.authors     = [ "Morten Primdahl" ]
  s.email       = "primdahl@me.com"
  s.homepage    = "http://github.com/zendesk/kamcaptcha"
  s.files       = `git ls-files`.split("\n")
  s.license     = "Apache License Version 2.0"

  s.add_runtime_dependency("trollop", ">= 2.0")

  s.add_development_dependency("rake")
  s.add_development_dependency("bundler")
  s.add_development_dependency("rmagick")
  s.add_development_dependency("minitest")
  s.add_development_dependency("uuidtools", ">= 2.1.3")

  s.executables << "kamcaptcha"
end
