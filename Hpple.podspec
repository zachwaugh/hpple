Pod::Spec.new do |s|
  s.name         = "Hpple"
  s.version      = "0.3.0"
  s.summary      = "Hpple: A nice Objective-C wrapper on the XPathQuery library for parsing HTML."
  s.homepage     = "http://github.com/zachwaugh/hpple"
  s.license      = 'MIT'
  s.author       = { "Zach Waugh" => "zwaugh@gmail.com" }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'

  s.source       = { :git => "https://github.com/zachwaugh/hpple.git", :tag => "0.3.0" }
  s.source_files  = 'lib'
  s.library   = 'xml2.2'
  s.requires_arc = true
end
