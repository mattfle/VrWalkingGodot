extends Spatial

export(String) var PERFORMANCE_CSV_PATH = "user://performance.csv"

var perform_runtime_config = false
var ovr_init_config = null 
var ovr_performance = null


func _ready():
	# check if game is running in the editor and skip VR setup if that's the case
	if OS.has_feature("editor"):
		return
	
	ovr_performance = preload("res://addons/godot_ovrmobile/OvrPerformance.gdns").new()
	ovr_init_config = preload("res://addons/godot_ovrmobile/OvrInitConfig.gdns").new()
	var interface = ARVRServer.find_interface("OVRMobile")
	if interface:
		ovr_init_config.set_render_target_size_multiplier(1)

		if interface.initialize():
			get_viewport().arvr = true


func _process(_delta):
	# perform runtime VR setup only once and only if game is not running in the editor
	if not perform_runtime_config && not OS.has_feature("editor"):
		ovr_performance.set_clock_levels(1, 1)
		ovr_performance.set_extra_latency_mode(1)
		perform_runtime_config = true
