extends Node3D

var empty = true

func _on_snap_spawn_has_picked_up(what: Variant) -> void:
	if not what is Exhibit:
		return
	if not what.just_spawned:
		$AudioDespawn.play()
		what.call_deferred("queue_free")
	else:
		empty = false
		what.just_spawned = false

func _on_snap_spawn_has_dropped() -> void:
	empty = true
