extends Node3D

@onready var lever_handle = get_node("LeverHandle")
@onready var lever_pivot : Node3D = get_node("LeverPivot")
@onready var lever_pickup : XRToolsPickable = get_node("LeverPivot/LeverPickup")
@onready var lever_pivot_start = lever_pivot.global_transform
@onready var lever_grab_target : Node3D = get_node("LeverHandle/GrabTarget")

var lever_status = false
const min_lever_rotation = deg_to_rad(-60.0)
const max_lever_rotation = deg_to_rad(60.0)
const abs_lever_rotation = max_lever_rotation-min_lever_rotation
const thresh_lever_rotation = deg_to_rad(10.0)
const max_lever_pullback = 2.0*0.113
var lever_last_position = min_lever_rotation

func _process(_delta: float) -> void:
	if lever_pickup.is_picked_up():
		var lever_pickup_pos = lever_pickup.global_transform.origin
		var lever_pickup_local = lever_pivot.to_local(lever_pickup_pos)

		var pullback = max(0.0, lever_pickup_local.z)
		if pullback < max_lever_pullback:
			lever_handle.rotation.x = min_lever_rotation + abs_lever_rotation*(pullback/max_lever_pullback)
		else:
			lever_pickup.picked_up_by.drop_object()
		
		var dist = abs(lever_handle.rotation.x-thresh_lever_rotation)
		if dist < 0.3 and abs(dist-lever_last_position) > 0.1:
			$AudioLeverMove.play()
			lever_last_position = dist

func _on_lever_pickup_picked_up(_pickable: Variant) -> void:
	$AudioLeverGrab.play()
	
func _on_lever_pickup_dropped(_pickable: Variant) -> void:
	if lever_handle.rotation.x >= thresh_lever_rotation:
		lever_handle.rotation.x = max_lever_rotation
		status_change(true)
	else:
		lever_handle.rotation.x = min_lever_rotation
		status_change(false)
	lever_pivot.global_transform = lever_pivot_start
	lever_pickup.global_transform = lever_grab_target.global_transform
	$AudioLeverSwitch.play()

func status_change(status:bool) -> void:
	if status == lever_status:
		return
		
	lever_status = status
	$TimerSwitch.start()

func _on_timer_sound_timeout() -> void:
	$AudioStatusChange.play()
	if lever_status == true:
		Library.switch_to_ar()
	else:
		Library.switch_to_vr()
