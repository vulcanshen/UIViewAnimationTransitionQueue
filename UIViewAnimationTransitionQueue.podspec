Pod::Spec.new do |s|
  s.name             = 'UIViewAnimationTransitionQueue'
  s.version          = '0.1.1'
  s.summary          = 'Easy to chain UIView animation or transition or both'
 
  s.description      = <<-DESC
Make UIView animation or transition chain easy to manipulate.
                       DESC
 
  s.homepage         = 'https://github.com/shenyun2304/UIViewAnimationTransitionQueue'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sHEnYuN' => 'shenyun23.4@gmail.com' }
  s.source           = { :git => 'https://github.com/shenyun2304/UIViewAnimationTransitionQueue.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'UIViewAnimationTransitionQueue/UIViewAnimationTransitionQueue.swift'
 
end