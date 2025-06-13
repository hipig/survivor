extends Node
class_name FileLoader

static func load_directory_to_dict(
	dir_path: String, 
	extensions: Array[String] = [], 
	use_subdir_as_key: bool = false,
	include_subdirs: bool = true
) -> Dictionary:
	var result := {}
	var dir := DirAccess.open("res://" + dir_path)

	if not dir:
		push_error("无法打开目录: " + dir_path)
		return {}
	
	_scan_directory(dir, dir_path, extensions, use_subdir_as_key, include_subdirs, result)
	return result
	
# 递归扫描目录
static func _scan_directory(
	dir: DirAccess,
	current_path: String,
	extensions: Array[String],
	use_subdir_as_key: bool,
	include_subdirs: bool,
	result: Dictionary
) -> void:
	dir.list_dir_begin()
	
	var file_name := dir.get_next()
	while file_name != "":
		var full_path := current_path.path_join(file_name)
		if dir.current_is_dir():
			if include_subdirs and file_name != "." and file_name != "..":
				var subdir := DirAccess.open(full_path)
				if subdir:
					if use_subdir_as_key:
						result[file_name] = {}
						_scan_directory(subdir, full_path, extensions, false, include_subdirs, result[file_name])
					else:
						_scan_directory(subdir, full_path, extensions, use_subdir_as_key, include_subdirs, result)
		else:
			if extensions.is_empty() or file_name.get_extension() in extensions:
				var resource = ResourceLoader.load(full_path)
				if resource:
					var key := file_name.get_basename()
					if use_subdir_as_key:
						var subdir_name := current_path.get_file()
						if not result.has(subdir_name):
							result[subdir_name] = {}
						result[subdir_name][key] = resource
					else:
						result[key] = resource
		
		file_name = dir.get_next()
	
	dir.list_dir_end()	
