extends Node3D

@onready var snap_zone = get_node("Table/Scale/SnapZone")
@onready var scale_origin : Vector3
@onready var snap_origin : Vector3 = snap_zone.position

func _ready() -> void:
	scale_origin = get_node("Table/Scale").global_position + \
		Vector3(0.05,0.0,-0.05)

func _on_snap_zone_has_picked_up(what: Variant) -> void:
	if not what is Exhibit:
		return
	
	$HelpInspection.visible = false
	
	var aabb : AABB = what.aabb
	snap_zone.position = Vector3(0.05,0.002,-0.05) + Vector3(aabb.size.x*0.5, 0.0, -aabb.size.z*0.5)
	what.scale_to_original()
	Library.update_information.emit(what.library_id)

func _on_snap_zone_has_dropped() -> void:
	snap_zone.position = snap_origin
	Library.update_information.emit(-1)
