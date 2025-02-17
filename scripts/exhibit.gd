extends XRToolsPickable

class_name Exhibit

@export var aabb : AABB
@export var custom_scale = 1.0
@export var scale_node : Node3D = null
var library_id = 0
var just_spawned = true
var is_scaled = false
var collision_original = []
var collision_scaled = []

func _init() -> void:
	collision_layer = 0
	set_collision_layer_value(3, true)
	
	collision_mask = 0
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(18, true)

	add_to_group("Exhibits", true)
	release_mode = XRToolsPickable.ReleaseMode.UNFROZEN
	second_hand_grab = XRToolsPickable.SecondHandGrab.SWAP
	
	picked_up.connect(_on_picked_up)
	
func scale_to_custom_size() -> void:
	if is_scaled or !scale_node:
		return
	scale_node.scale = Vector3(custom_scale, custom_scale, custom_scale)
	is_scaled = true

func scale_to_original() -> void:
	if !is_scaled or !scale_node:
		return
	scale_node.scale = Vector3(1.0, 1.0, 1.0)
	is_scaled = false
	
func _on_picked_up(_pickable:Variant) -> void:
	scale_to_custom_size()
	
	
