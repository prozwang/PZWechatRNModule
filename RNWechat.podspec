require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNWechat"
  s.version      = package["version"]
  s.summary      = package["description"]
 
  s.homepage     = "https://github.com/github-account/react-native-wechat"
  s.license      = "MIT"
  s.authors      = { "author-name" => "author-email@gmail.com" }
  s.platforms    = { :ios => "9.0", :tvos => "10.0" }
  s.source       = { :git => "https://github.com/github-account/react-native-wechat.git", :tag => "#{s.version}" }

  s.source_files = "ios/Wechat/**/*.{h,m,swift}"
  s.dependency "React"
  s.dependency "WechatOpenSDK", "1.8.6"
end
