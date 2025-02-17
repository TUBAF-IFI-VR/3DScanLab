extends Panel

@onready var container = get_node("VBoxContainer/MarginContainer/VBoxContainer")
@onready var texture_rect = container.get_node("HBoxContainer/Image")
@onready var label_name = container.get_node("HBoxContainer/LabelName")
@onready var grid_metadata = container.get_node("GridMetadata")

func _ready() -> void:
	Library.update_information.connect(self.update)
	reset()
	
func reset() -> void:
	texture_rect.texture = null
	label_name.text = ""
	
	for c in grid_metadata.get_children():
		grid_metadata.remove_child(c)
		c.queue_free()
	
func update(id:int) -> void:
	if id < 0:
		reset()
		return
	
	var e = Library.exhibits[id]
	var img = load(Library.base_path+e["thumbnail"])
	texture_rect.texture = img
	label_name.text = e["name"]
	
	for key in e["metadata"]:
		var label_descr = Label.new()
		var label_value = Label.new()
		
		label_descr.custom_minimum_size.x = 256
		label_descr.size_flags_vertical = Control.SIZE_FILL
		label_descr.text = key
		
		var values = e["metadata"][key].split(",")
		for v in values:
			label_value.text += v+"\n"
		
		grid_metadata.add_child(label_descr)
		grid_metadata.add_child(label_value)
