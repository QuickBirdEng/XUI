Pod::Spec.new do |s|
  s.name                  = 'XUI'
  s.version               = '0.1.0'
  s.summary               = 'XUI makes modular, testable architectures for SwiftUI apps a breeze!'

  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage              = 'https://github.com/quickbirdstudios/XUI'
  s.source                = { :git => 'https://github.com/quickbirdstudios/XUI.git', :branch => 'main' }
  s.author                = 'QuickBird Studios'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.swift_versions        = '5.3'
  s.source_files          = 'Sources/XUI/**/*.swift'

  s.frameworks            = 'SwiftUI', 'Combine'
end
