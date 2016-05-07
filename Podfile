platform :ios, '7.0'

def rbs_pods
	pod 'CocoaLumberjack'
	pod 'ReactiveCocoa'
	pod 'UINavigationBar+Addition'
	pod 'NSHash', '~> 1.1.0'
    pod 'RDVTabBarController'
	pod 'UINavigationBar+Addition'
end

target 'RBSAdmin' do
	xcodeproj './RBSAdmin/RBSAdmin.xcodeproj'
	rbs_pods
end

target 'RBSClient' do
	xcodeproj './RBSClient/RBSClient.xcodeproj'
	rbs_pods
end

workspace './RoomBookingSystem.xcworkspace'
