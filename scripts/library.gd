@tool
extends Node
## Global singleton to store the data of all exhibits
##

## Dictionary containing all exhibit properties
var exhibits = []
## Path to scene files and thumbnails
var base_path = "res://"


var xr_interface : XRInterface = null
var environment : Environment = null

## Signal emitted after loaded a library file successfully
signal library_updated

## Inform other nodes about the XR mode change
signal xr_mode_changed(new_mode:XRInterface.EnvironmentBlendMode)

## Signal emitted if a certain exhibit has been requested to spawn
signal spawn_exhibit(id:int)

## Trigger information display update
signal update_information(id:int)

## Load the library's JSON description
func load_from_file(filename:String) -> bool:
	if filename.is_empty():
		return false
		
	var file_content = FileAccess.get_file_as_string(filename)
	var dict = JSON.parse_string(file_content)
	base_path = dict["base_path"]
	exhibits = dict["exhibits"]
	
	library_updated.emit()
	return true
	
## Get the scene filename for the specified exhibit
func get_filename(id:int) -> String:
	return base_path+exhibits[id]["scene"]+".tscn"

func _on_xr_started() -> void:
	xr_interface = XRServer.primary_interface

func switch_to_ar() -> bool:
	if xr_interface:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
		elif XRInterface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ADDITIVE
		else:
			return false
	else:
		return false
		
	get_viewport().transparent_bg = true
	environment.background_mode = Environment.BG_CLEAR_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	xr_mode_changed.emit(xr_interface.environment_blend_mode)
	return true
	
func switch_to_vr():
	if xr_interface:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_OPAQUE in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_OPAQUE
		else:
			return false
	else:
		return false
		
	get_viewport().transparent_bg = false
	environment.background_mode = Environment.BG_SKY
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_BG
	xr_mode_changed.emit(xr_interface.environment_blend_mode)
	return true
