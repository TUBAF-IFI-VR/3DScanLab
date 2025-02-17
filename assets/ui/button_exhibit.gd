extends Button

class_name ButtonExhibit
var exhibit_id

func assign_exhibit(id:int):
	exhibit_id = id
	
	$TextureRect.texture = load(Library.base_path+Library.exhibits[id]["thumbnail"])

func _on_button_up() -> void:
	Library.spawn_exhibit.emit(exhibit_id)
