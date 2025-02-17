extends Panel

@onready var label_fps : Label = find_child("LabelFPSValue")

@onready var color_passthrough : ColorRect = find_child("ColorPassthrough")
@onready var color_xrmode : ColorRect = find_child("ColorXRMode")
@onready var label_passthrough : Label = find_child("LabelPassthrough")
@onready var label_xrmode : Label = find_child("LabelXRMode")

const refresh_rate = 1.0
var last_refresh = 100.0

func _ready() -> void:
	var xr_interface:XRInterface = XRServer.primary_interface
	if xr_interface:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes \
			or XRInterface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
			color_passthrough.color = Color(0.0, 1.0, 0.0)
			label_passthrough.text = "Passthrough available"
		else:
			color_passthrough.color = Color(1.0, 0.0, 0.0)
			label_passthrough.text = "Passthrough unavailable"
		
		if xr_interface.environment_blend_mode in \
			[XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND, XRInterface.XR_ENV_BLEND_MODE_ADDITIVE]:
			color_xrmode.color = Color(0.0, 1.0, 0.0)
			label_xrmode.text = "AR mode"
		else:
			color_xrmode.color = Color(1.0, 0.0, 0.0)
			label_xrmode.text = "VR mode"

func _process(delta: float) -> void:
	if last_refresh >= refresh_rate:
		last_refresh = 0.0
		refresh()
	else:
		last_refresh += delta

func refresh() -> void:
	var fps = Engine.get_frames_per_second()
	
	label_fps.text = str(fps)
