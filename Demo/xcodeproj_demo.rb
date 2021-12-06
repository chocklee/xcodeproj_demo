require 'xcodeproj'

path = 'Demo.xcodeproj'
project = Xcodeproj::Project.open(path)

schemes = Xcodeproj::Project.schemes(path)
puts '----scheme----'
schemes.each do |scheme|
	puts scheme
end

#获取所以target
puts '----target name----'
project.targets.each do |target|
	puts target.name
end

#获取target的source file
target = project.targets.first
files = target.source_build_phase.files.to_a.map do |pbx_build_file|
	pbx_build_file.file_ref.real_path.to_s

end.select do |path|
	path.end_with?(".m", ".mm", ".swift")

end.select do |path|
	File.exists?(path)
end
puts files

#获取target的build configuration
project.targets.each do |target|
	target.build_configurations.each do |config|
		if config.name == "Debug"
			puts config.build_settings
		end
	end
end


target.build_configurations.each do |config|
	if config.name == "Debug"
		# 修改描述文件名称
		config.build_settings["PROVISIONING_PROFILE_SPECIFIER"] = "DemoProfileName"

		# 新增配置
		config.build_settings['MY_CUSTOM_FLAG'] ||= 'TRUE'
	end
end

# #添加文件
# new_path = File.join("Demo")
# #找到要插入的group (参数中true表示如果找不到group，就创建一个group)
# group = project.main_group.find_subpath(new_path, true)
# #设置一下sorce_tree
# group.set_source_tree("SOURCE_ROOT")

# #向group中增加文件引用（.h文件只需引用一下，.m、.swift文件引用后还需add一下）
# file_ref = group.new_reference(File.join(project.project_dir, "/Demo/AddFileToGroup.swift"))
# target.add_file_references([file_ref])


workspace = Xcodeproj::Workspace.new_from_xcworkspace('Demo.xcworkspace')
puts workspace.to_s

puts project.path

#调用save方法保存，重新生成.pbxproj文件
project.save


