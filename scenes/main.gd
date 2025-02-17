extends Node3D

## JSON file containing base path and properties of all exhibits.
@export_file("*.json") var library_file : String = ""

## Parent node for all spawned exhibits
@onready var spawn1 : Node3D = get_node("SpawnDesk/Table/Pedestal1")
@onready var spawn2 : Node3D = get_node("SpawnDesk/Table/Pedestal2")

func _ready() -> void:
	if library_file.is_empty():
		push_error("No library JSON file has been specified!")
	if !Library.load_from_file(library_file):
		push_error("Failed to load library file '%s'!"%library_file)

	$StartXR.xr_started.connect(Library._on_xr_started)
	Library.environment = $WorldEnvironment.environment
	Library.spawn_exhibit.connect(self.spawn_exhibit)
	Library.xr_mode_changed.connect(self._on_xr_mode_changed)
	
	#spawn_exhibit(0)
	
func spawn_exhibit(id:int):
	var spawn = null
	if spawn1.empty:
		spawn = spawn1
	elif spawn2.empty:
		spawn = spawn2
	else:
		return
	
	var scene : PackedScene = load(Library.get_filename(id))
	
	var node : Exhibit = scene.instantiate()
	node.library_id = id
	node.scale_to_custom_size()
	node.position.y = 0.1
	#node.freeze = true
	node.gravity_scale = 0.1
	node.linear_damp = 0.5
	node.angular_damp = 0.5
	spawn.add_child(node)

func _on_xr_mode_changed(new_mode:XRInterface.EnvironmentBlendMode) -> void:
	if new_mode == XRInterface.XR_ENV_BLEND_MODE_OPAQUE:
		$Laboratory.visible = true
	else:
		$Laboratory.visible = false
