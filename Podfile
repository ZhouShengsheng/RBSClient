platform :ios, '7.0'
use_frameworks!

def rbs_pods
	pod 'CocoaLumberjack'
	pod 'ReactiveCocoa'
	pod 'UINavigationBar+Addition'
	pod 'NSHash', '~> 1.1.0'
    pod 'RDVTabBarController'
	pod 'UINavigationBar+Addition'
	pod 'MBProgressHUD', '~> 0.9.2'
	pod 'MJRefresh'
	pod 'SWTableViewCell', '~> 0.3.7'
	pod 'BEMCheckBox'
	pod 'ActionSheetPicker-3.0'
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
