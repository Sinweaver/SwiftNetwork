Pod::Spec.new do |s|

  s.name           = 'SwiftNetwork'
  s.version        = '1.0.4'
  s.license        = { :type => 'MIT' }
  s.summary        = 'Lightweight network manager.'
  s.homepage       = 'https://github.com/Sinweaver/SwiftNetwork'
  s.authors        = { 'Alexander Borovikov' => 'alexander.borovikov@outlook.com' }
  s.source         = { :git => 'https://github.com/Sinweaver/SwiftNetwork.git', :tag => s.version }
 
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.swift_versions = ['5.1', '5.2']

  s.source_files   = 'Sources/**/*'

  s.frameworks     = 'Foundation'
end
