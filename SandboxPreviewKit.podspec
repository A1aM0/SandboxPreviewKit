Pod::Spec.new do |spec|
  spec.name         = "SandboxPreviewKit"
  spec.version      = "0.0.1"
  spec.summary      = "Preview sandbox directory on iOS devices."
  spec.description  = "SandboxPreviewKit help you to preview sandbox directory on iOS devices."

  spec.homepage     = "https://github.com/A1aM0/SandboxPreviewKit"
  spec.license      = "MIT"
  spec.author             = { "Songhao Yang" => "yoyoyanghao@gmail.com" }
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  spec.source       = { :git => "https://github.com/A1aM0/SandboxPreviewKit.git", :tag => "#{spec.version}" }

  spec.source_files  = "Source", "Source/**/*.{h,m}"
  spec.exclude_files = "Source/Exclude"
  spec.public_header_files = "Source/**/*.h"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"
  spec.framework  = "UIKit"
  # spec.frameworks = "SomeFramework", "AnotherFramework"
  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
