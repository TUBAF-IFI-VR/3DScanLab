extends Panel

var ButtonScene : PackedScene = preload("res://assets/ui/button_exhibit.tscn")

@onready var GridModels = get_node("VBoxContainer/ScrollContainer/GridModels")

func _init():
	Library.library_updated.connect(self.update_menu)
	
func update_menu():
	for i in len(Library.exhibits):
		var btn : ButtonExhibit = ButtonScene.instantiate()
		btn.assign_exhibit(i)
		GridModels.add_child(btn)
		
