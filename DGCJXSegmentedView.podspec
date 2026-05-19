
Pod::Spec.new do |s|
  s.name         = "DGCJXSegmentedView"
  s.version = "1.3.3"
  s.summary      = "一个轻量级、配置丰富、灵活扩展的分段控制器"
  s.homepage     = "https://github.com/pujiaxin33/DGCJXSegmentedView"
  s.license      = "MIT"
  s.author       = { "pujiaxin33" => "317437084@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_version = "5.0"
  s.source           = { :git => 'https://github.com/wangweiqi864-hue/DGCJXSegmentedView.git', :tag => s.version.to_s }
  s.framework    = "UIKit"
  s.source_files  = "Sources", "Sources/**/*.{swift}"
  s.resource_bundles = {"DGCJXSegmentedView" => ["Sources/PrivacyInfo.xcprivacy"]}
  s.requires_arc = true
end
